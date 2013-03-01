package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.NotPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.predicate.WithinPredicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.util.SearchTypeValidator;
import org.gbif.api.util.VocabularyUtils;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import com.google.common.base.Splitter;
import com.google.common.collect.Lists;

/**
 * Utility for dealing with the decoding of the request parameters to the
 * query object to pass into the service.
 * This parses the URL params which should be from something like the following
 * into a predicate suitable for launching a download service.
 *
 * It understands multi valued parameters and interprets the range format [* TO 100]
 * TAXON_KEY=12&ALTITUDE=gt,10 (ALTITUDE > 10)
 */
public class PredicateFactory {

  private final static Splitter RANGE_SPLITTER = Splitter.on(",").trimResults().limit(2);

  /**
   * Enum that contains the supported predicates and their value used to prefix query parameters.
   */
  private enum Operator {
    EQUALS("eq"), LIKE("lk"), GREATER_THAN("gt"), LESS_THAN("lt"), GREATER_THAN_OR_EQUAL("gte"),
    LESS_THAN_OR_EQUAL("lte");

    private final String prefix;

    Operator(String prefix) {
      this.prefix = prefix;
    }

    public String getPrefix() {
      return prefix;
    }
  }

  private final static Predicate MATCH_ALL = new NotPredicate(new EqualsPredicate(OccurrenceSearchParameter.ALTITUDE,
    "100000"));

  /**
   * Builds a full predicate filter from the parameters.
   * In case no filters exist still return a predicate that matches anything.
   * 
   * @return always some predicate
   */
  public Predicate build(Map<String, String[]> params) {
    // predicates for different parameters. If multiple values for the same parameter exist these are in here already
    List<Predicate> groupedByParam = Lists.newArrayList();
    for (Entry<String, String[]> entry : params.entrySet()) {
      // recognize valid params by enum name, ignore others
      OccurrenceSearchParameter param = toEnumParam(entry.getKey());
      if (param != null) {
        // valid parameter
        Predicate predicate = buildParamPredicate(param, entry.getValue());
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

  private Predicate buildParamPredicate(OccurrenceSearchParameter param, String[] values) {
    List<Predicate> predicates = Lists.newArrayList();
    for (String v : values) {
      predicates.add(parsePredicate(param, v));
    }

    if (predicates.isEmpty()) {
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
    // for example comma is likely to occur also in the actual value

    for (Operator op : Operator.values()) {
      String opPrefix = op.getPrefix() + ',';
      if (value.startsWith(opPrefix)) {
        final String cleanValue = value.replaceFirst(opPrefix, "");
    // test for ranges
    if (SearchTypeValidator.isRange(value)) {
      Iterator<String> iter = RANGE_SPLITTER.split(value).iterator();
      Predicate from = new GreaterThanOrEqualsPredicate(param, iter.next());
      Predicate until = new LessThanOrEqualsPredicate(param, iter.next());
      return new ConjunctionPredicate(Lists.newArrayList(from, until));

          case LIKE:
            return new LikePredicate(param, cleanValue);

          case GREATER_THAN:
            return new GreaterThanPredicate(param, cleanValue);

          case GREATER_THAN_OR_EQUAL:
            return new GreaterThanOrEqualsPredicate(param, cleanValue);

          case LESS_THAN:
            return new LessThanPredicate(param, cleanValue);

          case LESS_THAN_OR_EQUAL:
            return new LessThanOrEqualsPredicate(param, cleanValue);

          default:
            return new EqualsPredicate(param, value);
        }
      }
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

}
