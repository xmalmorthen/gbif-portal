/**
 * 
 */
package org.gbif.portal.action.occurrence.util;

import org.gbif.occurrencestore.download.api.model.predicate.ConjunctionPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.DisjunctionPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.EqualsPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.GreaterThanPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.LessThanPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.Predicate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility for dealing with the decoding of the request parameters to the
 * query object to pass into the service.
 * This parses the URL params which should be from something like the following
 * into a predicate suitable for launching a download service.
 * f[0].s=1 & f[0].p=0 & f[0].v=Puma concolor
 */
public class PredicateFactory {

  // This is a placeholder to map from the JSON definition for the UI to
  // that needed by the Predicate
  private enum TypeMapping {
    EQUALS("0"), STARTS_WITH("1"), GREATER_THAN("2"), LESS_THAN("3");

    private final String id;

    TypeMapping(String id) {
      this.id = id;
    }

    public String getValue() {
      return id;
    }
  }

  private static final Logger LOG = LoggerFactory.getLogger(PredicateFactory.class);

  // This is a placeholder to map from the JSON definition ID to the query field
  private static final Map<String, String> QUERY_FIELD_MAPPING = Maps.newHashMap();
  static {
    QUERY_FIELD_MAPPING.put("1", "scientific_name");
    QUERY_FIELD_MAPPING.put("4", "country");
    QUERY_FIELD_MAPPING.put("6", "latitude");
    QUERY_FIELD_MAPPING.put("7", "longitude");
    QUERY_FIELD_MAPPING.put("8", "altitude");
    QUERY_FIELD_MAPPING.put("9", "depth");
    QUERY_FIELD_MAPPING.put("18", "institution_code");
    QUERY_FIELD_MAPPING.put("19", "collection_code");
    QUERY_FIELD_MAPPING.put("20", "catalogue_number");
  }

  // Pattern to detect the ID and type of filters from e.g.
  // f[11].s f[1].p f[0].v
  private final static Pattern SUBJECT = Pattern.compile("f\\[(\\d+)\\]\\.[s]");
  private final static Pattern PREDICATE = Pattern.compile("f\\[(\\d+)\\]\\.[p]");
  private final static Pattern VALUE = Pattern.compile("f\\[(\\d+)\\]\\.[v]");

  public Predicate build(Map<String, String[]> params) {
    if (LOG.isDebugEnabled()) {
      for (String k : params.keySet()) {
        LOG.debug("{}: {}", k, params.get(k)[0]);
      }
    }

    // Group the filters so to enable OR'ing between single terms
    // and AND'ing between the groups
    List<Triple> filters = parse(params);

    List<Predicate> grouped = collect(filters);
    if (grouped.size() == 1) {
      return grouped.get(0);

    } else {
      return new ConjunctionPredicate(grouped);
    }
  }

  /**
   * Converts the triple to a predicate
   */
  private Predicate build(Triple t) {
    if (QUERY_FIELD_MAPPING.containsKey(t.getSubject())) {
      if (TypeMapping.EQUALS.getValue().equals(t.getPredicate())) {
        return new EqualsPredicate(QUERY_FIELD_MAPPING.get(t.getSubject()), t.getValue());
      } else if (TypeMapping.GREATER_THAN.getValue().equals(t.getPredicate())) {
        return new GreaterThanPredicate(QUERY_FIELD_MAPPING.get(t.getSubject()), t.getValue());
      } else if (TypeMapping.LESS_THAN.getValue().equals(t.getPredicate())) {
        return new LessThanPredicate(QUERY_FIELD_MAPPING.get(t.getSubject()), t.getValue());
      }
    } else {
      LOG.warn("Query mapping does not contain {}", t.getSubject());
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
   * Reads all the params and spits them out in a digestible form Note that the ordering is
   * not preserved. E.g. f[0] might not be the first in the list, but that is irrelevant
   */
  private List<Triple> parse(Map<String, String[]> params) {
    Map<String, String> s = new HashMap<String, String>();
    Map<String, String> p = new HashMap<String, String>();
    Map<String, String> v = new HashMap<String, String>();
    for (String param : params.keySet()) {
      Matcher m = SUBJECT.matcher(param);
      if (m.matches()) {
        s.put(m.group(1), params.get(param)[0]); // only pull the first - an issue?
        continue;
      }
      m = PREDICATE.matcher(param);
      if (m.matches()) {
        p.put(m.group(1), params.get(param)[0]); // only pull the first - an issue?
        continue;
      }
      m = VALUE.matcher(param);
      if (m.matches()) {
        v.put(m.group(1), params.get(param)[0]); // only pull the first - an issue?
      }
    }

    List<Triple> t = Lists.newArrayList();
    // only return when all 3 are present anyway
    for (String k : s.keySet()) {
      if (p.containsKey(k) && v.containsKey(k)) {
        t.add(new Triple(s.get(k), p.get(k), v.get(k)));
      }
    }
    return t;
  }
}