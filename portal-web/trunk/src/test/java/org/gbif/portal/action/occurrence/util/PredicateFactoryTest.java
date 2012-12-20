package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.google.common.collect.Maps;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class PredicateFactoryTest {

  @Test
  public void testBuild() {
    PredicateFactory pf = new PredicateFactory();
    Map<String, String[]> params = new HashMap<String, String[]>();
    params.put("f[0].s", new String[] {"BASIS_OF_RECORD"});
    params.put("f[0].p", new String[] {"0"}); // equals
    params.put("f[0].v", new String[] {"PRESERVED_SPECIMEN"});
    Predicate p = pf.build(params);

    assertTrue(p instanceof EqualsPredicate);
    EqualsPredicate eq = (EqualsPredicate) p;
    assertEquals(OccurrenceSearchParameter.BASIS_OF_RECORD, eq.getKey());
    assertEquals("PRESERVED_SPECIMEN", eq.getValue());

    // add a second country to check an OR is built
    params.put("f[1].s", new String[] {"BASIS_OF_RECORD"});
    params.put("f[1].p", new String[] {"0"}); // equals
    params.put("f[1].v", new String[] {"OBSERVATION"});
    p = pf.build(params);
    assertTrue(p instanceof DisjunctionPredicate);
    DisjunctionPredicate dq = (DisjunctionPredicate) p;
    assertEquals(2, dq.getPredicates().size());
    Iterator<Predicate> iter = dq.getPredicates().iterator();
    p = iter.next();
    assertTrue(p instanceof EqualsPredicate);
    eq = (EqualsPredicate) p;
    assertEquals(OccurrenceSearchParameter.BASIS_OF_RECORD, eq.getKey());
    assertEquals("OBSERVATION", eq.getValue());
    p = iter.next();
    assertTrue(p instanceof EqualsPredicate);
    eq = (EqualsPredicate) p;
    assertEquals(OccurrenceSearchParameter.BASIS_OF_RECORD, eq.getKey());
    assertEquals("PRESERVED_SPECIMEN", eq.getValue());

    // add a third to check an AND is built
    params.put("f[2].s", new String[] {"LATITUDE"});
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
    assertEquals(OccurrenceSearchParameter.LATITUDE, gp.getKey());
    assertEquals("10.00", gp.getValue());
  }


  @Test
  public void testOR() {
    PredicateFactory pf = new PredicateFactory();
    Map<String, String[]> params = Maps.newHashMap();

    params.put("f[0].s", new String[] {"CATALOG_NUMBER"});
    params.put("f[0].p", new String[] {"0"}); // equals
    params.put("f[0].v", new String[] {"A"});

    params.put("f[1].s", new String[] {"CATALOG_NUMBER"});
    params.put("f[1].p", new String[] {"0"}); // equals
    params.put("f[1].v", new String[] {"B"});
    Predicate p = pf.build(params);
    assertTrue(p instanceof DisjunctionPredicate);
  }
}
