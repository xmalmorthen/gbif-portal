/**
 *
 */
package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.predicate.SimplePredicate;
import org.gbif.api.model.registry.geospatial.BoundingBox;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.common.base.Enums;
import com.google.common.base.Objects;
import com.google.common.collect.Lists;
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


  public class BetweenPredicate extends SimplePredicate {

    private final String valueMax;


    public BetweenPredicate(String key, String valueMin, String valueMax) {
      super(key, valueMin);
      this.valueMax = valueMax;
    }

    @Override
    public boolean equals(Object obj) {
      if (this == obj) {
        return true;
      }

      if (!(obj instanceof BetweenPredicate)) {
        return false;
      }

      BetweenPredicate that = (BetweenPredicate) obj;
      return Objects.equal(this.getKey(), that.getKey()) && Objects.equal(this.getValue(), that.getValue())
        && Objects.equal(this.getValueMax(), that.getValueMax());
    }

    /**
     * @return the valueMax
     */
    public String getValueMax() {
      return valueMax;
    }
  }


  public class BoundingBoxPredicate implements Predicate {

    private final String key;

    private final BoundingBox value;


    public BoundingBoxPredicate(String key, BoundingBox value) {
      this.value = value;
      this.key = key;
    }

    @Override
    public boolean equals(Object obj) {
      if (this == obj) {
        return true;
      }

      if (!(obj instanceof BetweenPredicate)) {
        return false;
      }

      BetweenPredicate that = (BetweenPredicate) obj;
      return Objects.equal(this.getKey(), that.getKey()) && Objects.equal(this.getValue(), that.getValue());
    }


    /**
     * @return the key
     */
    public String getKey() {
      return key;
    }


    /**
     * @return the value
     */
    public BoundingBox getValue() {
      return value;
    }


  }
  // This is a placeholder to map from the JSON definition for the UI to
  // that needed by the Predicate
  private enum TypeMapping {
    EQUALS("0"), GREATER_THAN("1"), LESS_THAN("2"), STARTS_WITH("3"), BETWEEN("4"), BOUNDING_BOX("5");

    private final String id;

    TypeMapping(String id) {
      this.id = id;
    }

    public String getValue() {
      return id;
    }
  }


  private static final Logger LOG = LoggerFactory.getLogger(PredicateFactory.class);

  // Pattern to detect the ID and type of filters from e.g.
  // f[11].s f[1].p f[0].v
  private final static Pattern SUBJECT = Pattern.compile("f\\[(\\d+)\\]\\.[s]");
  private final static Pattern PREDICATE = Pattern.compile("f\\[(\\d+)\\]\\.[p]");
  private final static Pattern VALUE = Pattern.compile("f\\[(\\d+)\\]\\.[v]");

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
   * Converts the triple to a predicate
   */
  private Predicate build(Triple t) {

    if (TypeMapping.EQUALS.getValue().equals(t.getPredicate())) {
      return new EqualsPredicate(t.getSubject(), t.getValue());
    } else if (TypeMapping.GREATER_THAN.getValue().equals(t.getPredicate())) {
      return new GreaterThanPredicate(t.getSubject(), t.getValue());
    } else if (TypeMapping.LESS_THAN.getValue().equals(t.getPredicate())) {
      return new LessThanPredicate(t.getSubject(), t.getValue());
    } else if (TypeMapping.BETWEEN.getValue().equals(t.getPredicate())) {
      // The value comes in form minValue,maxValue
      String splitValue[] = t.getValue().split(",");
      return new BetweenPredicate(t.getSubject(), splitValue[0], splitValue[1]);
    } else if (TypeMapping.BOUNDING_BOX.getValue().equals(t.getPredicate())) {
      // The value comes in form minValue,maxValue
      String splitValue[] = t.getValue().split(",");
      BoundingBox bbox =
        new BoundingBox(Double.parseDouble(splitValue[0]), Double.parseDouble(splitValue[1]),
          Double.parseDouble(splitValue[2]), Double.parseDouble(splitValue[3]));
      return new BoundingBoxPredicate(t.getSubject(), bbox);
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
      if (Enums.getIfPresent(OccurrenceDownloadParameter.class, param).isPresent()) {
        s.put(param, param);
        for (String value : params.get(param)) {
          p.put(param, TypeMapping.EQUALS.getValue());
          v.put(param, value);
        }
        continue;
      }
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
