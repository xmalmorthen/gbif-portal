package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.predicate.SimplePredicate;
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
    params.put("BASIS_OF_RECORD", new String[] {"PRESERVED_SPECIMEN"});
    Predicate p = pf.build(params);

    assertTrue(p instanceof EqualsPredicate);
    EqualsPredicate eq = (EqualsPredicate) p;
    assertEquals(OccurrenceSearchParameter.BASIS_OF_RECORD, eq.getKey());
    assertEquals("PRESERVED_SPECIMEN", eq.getValue());

    // add a second country to check an OR is built
    params.put("BASIS_OF_RECORD", new String[] {"OBSERVATION", "PRESERVED_SPECIMEN"});
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
    params.put("LATITUDE", new String[] {"10.07, *"}); // greater than or equals
    p = pf.build(params);
    assertTrue(p instanceof ConjunctionPredicate);
    ConjunctionPredicate cq = (ConjunctionPredicate) p;
    assertEquals(2, cq.getPredicates().size());
    iter = cq.getPredicates().iterator();
    p = iter.next();
    assertTrue(p instanceof DisjunctionPredicate);
    p = iter.next();
    assertTrue(p instanceof GreaterThanOrEqualsPredicate); // the OR'ed scientific names (tested above)
    GreaterThanOrEqualsPredicate gp = (GreaterThanOrEqualsPredicate) p;
    assertEquals(OccurrenceSearchParameter.LATITUDE, gp.getKey());
    assertEquals("10.07", gp.getValue());
  }


  @Test
  public void testRange() {
    PredicateFactory pf = new PredicateFactory();
    Map<String, String[]> params = Maps.newHashMap();

    params.put("YEAR", new String[] {"1900", "1800,1840", "*, 1700", "2000 , *"});

    Predicate p = pf.build(params);
    assertTrue(p instanceof DisjunctionPredicate);
    DisjunctionPredicate or = (DisjunctionPredicate) p;
    assertEquals(4, or.getPredicates().size());
    Iterator<Predicate> iter = or.getPredicates().iterator();

    p = iter.next();
    assertSimplePredicate(p, EqualsPredicate.class, "1900", OccurrenceSearchParameter.YEAR);

    p = iter.next();
    assertTrue(p instanceof ConjunctionPredicate);
    ConjunctionPredicate and = (ConjunctionPredicate) p;
    assertEquals(2, and.getPredicates().size());
    Iterator<Predicate> andIter = and.getPredicates().iterator();
    assertSimplePredicate(andIter.next(), GreaterThanOrEqualsPredicate.class, "1800", OccurrenceSearchParameter.YEAR);
    assertSimplePredicate(andIter.next(), LessThanOrEqualsPredicate.class, "1840", OccurrenceSearchParameter.YEAR);

    p = iter.next();
    assertSimplePredicate(p, LessThanOrEqualsPredicate.class, "1700", OccurrenceSearchParameter.YEAR);

    p = iter.next();
    assertSimplePredicate(p, GreaterThanOrEqualsPredicate.class, "2000", OccurrenceSearchParameter.YEAR);
  }

  private void assertSimplePredicate(Predicate p, Class<? extends SimplePredicate> expectedClass, String expectedValue, OccurrenceSearchParameter expectedParam) {
    assertEquals(expectedClass, p.getClass());
    SimplePredicate sp = (SimplePredicate) p;
    assertEquals(expectedParam, sp.getKey());
    assertEquals(expectedValue, sp.getValue());
  }

  @Test
  public void testOR() {
    PredicateFactory pf = new PredicateFactory();
    Map<String, String[]> params = Maps.newHashMap();

    params.put("CATALOG_NUMBER", new String[] {"A", "B"});// equals

    Predicate p = pf.build(params);
    assertTrue(p instanceof DisjunctionPredicate);
  }
}
