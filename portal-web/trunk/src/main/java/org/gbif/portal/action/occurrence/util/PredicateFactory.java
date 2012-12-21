package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanPredicate;
import org.gbif.api.model.occurrence.predicate.LikePredicate;
import org.gbif.api.model.occurrence.predicate.NotPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.util.VocabularyUtils;

import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility for dealing with the decoding of the request parameters to the
 * query object to pass into the service.
 * This parses the URL params which should be from something like the following
 * into a predicate suitable for launching a download service.
 * TAXON_KEY=12&ALTITUDE=gt,10 (ALTITUDE > 10)
 */
public class PredicateFactory {

  private static final Logger LOG = LoggerFactory.getLogger(PredicateFactory.class);
  private final static Predicate MATCH_ALL = new NotPredicate(new EqualsPredicate(OccurrenceSearchParameter.ALTITUDE, "100000"));

  /**
   * Enum that contains the supported predicates and their value used to prefix query parameters.
   * TODO: do we really need the simple greater/less than or can we just use the greaterthanorequals variant?
   */
  private enum Operator {
    EQUALS("eq"), LIKE("lk"), GREATER_THAN("gt"), LESS_THAN("lt"), GREATER_THAN_OR_EQUAL("gte"), LESS_THAN_OR_EQUAL("lte");

    private final String prefix;

    Operator(String prefix) {
      this.prefix = prefix + ",";
    }

    public String getPrefix() {
      return prefix;
    }
  }

  /**
   * Builds a full predicate filter from the parameters.
   * In case no filters exist still return a predicate that matches anything.
   * @return always some predicate
   */
  public Predicate build(Map<String, String[]> params) {
    // predicates for different parameters. If multiple values for the same parameter exist these are in here already
    List<Predicate> groupedByParam = Lists.newArrayList();
    for (String p : params.keySet()) {
      // recognize valid params by enum name, ignore others
      OccurrenceSearchParameter param = toEnumParam(p);
      if (param != null) {
        // valid parameter
        Predicate predicate = buildParamPredicate(param, params.get(p));
        if (predicate != null) {
          groupedByParam.add(predicate);
        }
      }
    }

    if (groupedByParam.isEmpty()) {
      // use a stupid match all predicate for now as download requires an instance right now
      return MATCH_ALL;

    } else if (groupedByParam.size() == 1) {
      return groupedByParam.get(0);

    } else {
      // AND the individual params
      return new ConjunctionPredicate(groupedByParam);
    }
  }

  /**
   * @param name
   * @return the search enum or null if it cant be converted
   */
  private OccurrenceSearchParameter toEnumParam(String name) {
    try {
      return (OccurrenceSearchParameter) VocabularyUtils.lookupEnum(name, OccurrenceSearchParameter.class);
    } catch (IllegalArgumentException e) {
      return null;
    }
  }

  private Predicate buildParamPredicate(OccurrenceSearchParameter param, String[] values) {
    List<Predicate> predicates = Lists.newArrayList();
    for (String v : values) {
      predicates.add(parsePredicate(param, v));
    }

    if (predicates.isEmpty()) {
      // use a stupid match all predicate for now as download requires an instance right now
      return null;

    } else if (predicates.size() == 1) {
      return predicates.get(0);

    } else {
      // OR the individual params
      return new DisjunctionPredicate(predicates);
    }
  }

  /**
   * Converts a value with an optional predicate prefix into a real predicate instance, defaulting to EQUALS.
   */
  private Predicate parsePredicate(OccurrenceSearchParameter param, String value) {
    // iterate over the few possible prefixes and see if the string starts with it
    // this avoids splitting the string on special characters,
    // for example comma is likely to occurr also in the actual value
    for (Operator op : Operator.values()) {
      if (value.startsWith(op.getPrefix())) {
        final String cleanValue = value.replaceFirst(op.getPrefix(), "");

        switch (op) {
          case EQUALS:
            return new EqualsPredicate(param, cleanValue);

          case LIKE:
            return new LikePredicate(param, cleanValue);

          case GREATER_THAN:
            return  new GreaterThanPredicate(param, cleanValue);

          case GREATER_THAN_OR_EQUAL:
            return  new GreaterThanOrEqualsPredicate(param, cleanValue);

          case LESS_THAN:
            return  new LessThanPredicate(param, cleanValue);

          case LESS_THAN_OR_EQUAL:
            return  new LessThanOrEqualsPredicate(param, cleanValue);
        }
      }
    }

    // default to an equals predicate with the original value
    return new EqualsPredicate(param, value);
  }

}
