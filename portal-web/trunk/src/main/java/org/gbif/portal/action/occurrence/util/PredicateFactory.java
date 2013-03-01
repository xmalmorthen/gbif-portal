package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.predicate.WithinPredicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.util.SearchTypeValidator;
import org.gbif.api.util.VocabularyUtils;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.google.common.base.Splitter;
import com.google.common.collect.Lists;

/**
 * Utility for dealing with the decoding of the request parameters to the
 * query object to pass into the service.
 * This parses the URL params which should be from something like the following
 * into a predicate suitable for launching a download service.
 *
 * It understands multi valued parameters and interprets the range format *,100
 * TAXON_KEY=12&ALTITUDE=1000,2000
 * (ALTITUDE >= 1000 AND ALTITUDE <= 1000)
 */
public class PredicateFactory {

  private final static Splitter RANGE_SPLITTER = Splitter.on(",").trimResults().limit(2);

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
      // no filter at all
      return null;

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
    // geometry filters are special
    if (OccurrenceSearchParameter.GEOMETRY == param) {
      return new WithinPredicate(value);
    }

    // test for ranges
    if (SearchTypeValidator.isRange(value)) {
      Iterator<String> iter = RANGE_SPLITTER.split(value).iterator();
      return new ConjunctionPredicate(Lists.<Predicate>newArrayList(
        new GreaterThanOrEqualsPredicate(param, iter.next()), new LessThanOrEqualsPredicate(param, iter.next()))) ;

    } else {
      // defaults to an equals predicate with the original value
      return new EqualsPredicate(param, value);
    }
  }

}
