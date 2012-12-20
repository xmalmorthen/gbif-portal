package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.util.VocabularyUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

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

  /**
   * Enum that contains the supported predicates.
   */
  private enum TypeMapping {
    EQUALS("eq"), GREATER_THAN("gt"), LESS_THAN("lt"), GREATER_THAN_OR_EQUAL("gte"), LESS_THAN_OR_EQUAL("lte");

    private final String id;

    TypeMapping(String id) {
      this.id = id;
    }

    public String getValue() {
      return id;
    }
  }

  // Used to separate the predicate and value, e.g.: gt,10.
  private static final String SEPARATOR = ",";


  private static final Logger LOG = LoggerFactory.getLogger(PredicateFactory.class);


  /**
   * Builds a Conjunction or SimplePredicate from the parameters.
   */
  public Predicate build(Map<String, String[]> params) {

    // Group the filters so to enable OR'ing between single terms
    // and AND'ing between the groups
    List<Triple> filters = parse(params);

    if (filters.isEmpty()) {
      return null;
    } else {
      List<Predicate> grouped = collect(filters);
      if (grouped.size() == 1) {
        return grouped.get(0);
      } else {
        return new ConjunctionPredicate(grouped);
      }
    }
  }

  /**
   * Builds a single predicate using a Triple instance.
   */
  public Predicate build(Triple t) {
    Enum<?> occParam = VocabularyUtils.lookupEnum(t.getSubject(), OccurrenceSearchParameter.class);
    if (occParam != null) {
      OccurrenceSearchParameter occSearchParam = (OccurrenceSearchParameter) occParam;
      if (TypeMapping.EQUALS.getValue().equals(t.getPredicate())) {
        return new EqualsPredicate(occSearchParam, t.getValue());
      } else if (TypeMapping.GREATER_THAN.getValue().equals(t.getPredicate())) {
        return new GreaterThanPredicate(occSearchParam, t.getValue());
      } else if (TypeMapping.LESS_THAN.getValue().equals(t.getPredicate())) {
        return new LessThanPredicate(occSearchParam, t.getValue());
      }
    }

    // first basic implementation does not support the given fields
    LOG.warn("No way to create Predicate for given fields {}", t);
    return null;
  }


  /**
   * Takes the triples and collects them into common groups.
   * E.g. 2 triples for "scientific name equals" will be grouped into one disjoint predicate (OR)
   */
  private List<Predicate> collect(List<Triple> filters) {
    Map<Duplex, List<Predicate>> index = new HashMap<Duplex, List<Predicate>>();
    for (Triple t : filters) {
      Duplex key = new Duplex(t);
      if (!index.containsKey(key)) {
        List<Predicate> l = Lists.newArrayList();
        index.put(key, l);
      }
      Predicate p = build(t);
      index.get(key).add(p);
    }
    return collectDisjoint(index);
  }

  /**
   * Rewrite the map collecting common predicates into an OR group
   */
  private List<Predicate> collectDisjoint(Map<Duplex, List<Predicate>> index) {
    List<Predicate> result = Lists.newArrayList();
    for (Entry<Duplex, List<Predicate>> e : index.entrySet()) {
      if (e.getValue().size() > 1) {
        result.add(new DisjunctionPredicate(e.getValue()));
      } else if (e.getValue().size() == 1) {
        result.add(e.getValue().get(0));
      }
    }
    return result;
  }

  /**
   * Extracts the predicate of the "value" parameter.
   * e.g.: lt,9 returns lt
   */
  private String getPredicate(String value) {
    String parts[] = value.split(SEPARATOR);
    if (parts.length == 1) {
      return TypeMapping.EQUALS.getValue();
    } else {
      return parts[0];
    }
  }

  /**
   * Extracts the value of the "value" parameter.
   * e.g.: lt,9 returns 9
   */
  private String getValue(String value) {
    String parts[] = value.split(SEPARATOR);
    if (parts.length == 1) {
      return value;
    } else {
      return parts[1];
    }
  }

  /**
   * Reads all the params and spits them out in a digestible form Note that the ordering is
   * not preserved. E.g. f[0] might not be the first in the list, but that is irrelevant
   */
  private List<Triple> parse(Map<String, String[]> params) {
    List<Triple> t = Lists.newArrayList();
    for (String param : params.keySet()) {
      Enum<?> occSearchParam = VocabularyUtils.lookupEnum(param, OccurrenceSearchParameter.class);
      if (occSearchParam != null) {
        for (String value : params.get(param)) {
          t.add(new Triple(((OccurrenceSearchParameter) occSearchParam).name(), getPredicate(value), getValue(value)));
        }
      }
    }
    return t;
  }


}
