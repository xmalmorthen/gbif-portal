package org.gbif.portal.action.occurrence.util;

import org.gbif.occurrencestore.download.api.model.predicate.ConjunctionPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.DisjunctionPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.EqualsPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.GreaterThanPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.Predicate;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.google.common.collect.Maps;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class PredicateFactoryTest {

  private static final Map<String, String> QUERY_FIELD_MAPPING = Maps.newHashMap();
  static {
    QUERY_FIELD_MAPPING.put("1", "i_scientific_name");
    QUERY_FIELD_MAPPING.put("4", "country");
    QUERY_FIELD_MAPPING.put("6", "i_latitude");
    QUERY_FIELD_MAPPING.put("7", "i_longitude");
    QUERY_FIELD_MAPPING.put("8", "i_altitude");
    QUERY_FIELD_MAPPING.put("9", "i_depth");
    QUERY_FIELD_MAPPING.put("15", "i_year");
    QUERY_FIELD_MAPPING.put("16", "i_month");
    QUERY_FIELD_MAPPING.put("18", "institution_code");
    QUERY_FIELD_MAPPING.put("19", "collection_code");
    QUERY_FIELD_MAPPING.put("20", "catalogue_number");
  }

  @Test
  public void testBuild() {
    PredicateFactory pf = new PredicateFactory(QUERY_FIELD_MAPPING);
    Map<String, String[]> params = new HashMap<String, String[]>();
    params.put("f[0].s", new String[] {"1"});
    params.put("f[0].p", new String[] {"0"}); // equals
    params.put("f[0].v", new String[] {"Puma concolor"});
    Predicate p = pf.build(params);

    assertTrue(p instanceof EqualsPredicate);
    EqualsPredicate eq = (EqualsPredicate) p;
    assertEquals("i_scientific_name", eq.getKey());
    assertEquals("Puma concolor", eq.getValue());

    // add a second scientific name to check an OR is built
    params.put("f[1].s", new String[] {"1"});
    params.put("f[1].p", new String[] {"0"}); // equals
    params.put("f[1].v", new String[] {"Puma concolor"});
    p = pf.build(params);
    assertTrue(p instanceof DisjunctionPredicate);
    DisjunctionPredicate dq = (DisjunctionPredicate) p;
    assertEquals(2, dq.getPredicates().size());
    Iterator<Predicate> iter = dq.getPredicates().iterator();
    p = iter.next();
    assertTrue(p instanceof EqualsPredicate);
    eq = (EqualsPredicate) p;
    assertEquals("i_scientific_name", eq.getKey());
    assertEquals("Puma concolor", eq.getValue());
    p = iter.next();
    assertTrue(p instanceof EqualsPredicate);
    eq = (EqualsPredicate) p;
    assertEquals("i_scientific_name", eq.getKey());
    assertEquals("Puma concolor", eq.getValue());

    // add a third to check an AND is built
    params.put("f[2].s", new String[] {"6"});
    params.put("f[2].p", new String[] {"1"}); // greater than
    params.put("f[2].v", new String[] {"10.00"});
    p = pf.build(params);
    assertTrue(p instanceof ConjunctionPredicate);
    ConjunctionPredicate cq = (ConjunctionPredicate) p;
    assertEquals(2, cq.getPredicates().size());
    iter = cq.getPredicates().iterator();
    p = iter.next();
    assertTrue(p instanceof DisjunctionPredicate); // the OR'ed scientific names (tested above)
    p = iter.next();
    assertTrue(p instanceof GreaterThanPredicate);
    GreaterThanPredicate gp = (GreaterThanPredicate) p;
    assertEquals("i_latitude", gp.getKey());
    assertEquals("10.00", gp.getValue());
  }

  @Test
  public void testOR() {
    PredicateFactory pf = new PredicateFactory(QUERY_FIELD_MAPPING);
    Map<String, String[]> params = new HashMap<String, String[]>();

    params.put("f[0].s", new String[] {"1"});
    params.put("f[0].p", new String[] {"0"}); // equals
    params.put("f[0].v", new String[] {"A"});
    params.put("f[1].s", new String[] {"1"});
    params.put("f[1].p", new String[] {"0"}); // equals
    params.put("f[1].v", new String[] {"B"});
    Predicate p = pf.build(params);
    assertTrue(p instanceof DisjunctionPredicate);
  }
}
