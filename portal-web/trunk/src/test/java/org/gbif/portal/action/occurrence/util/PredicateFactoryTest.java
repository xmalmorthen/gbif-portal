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
    params.put("BASIS_OF_RECORD", new String[] {"eq,PRESERVED_SPECIMEN"});
    Predicate p = pf.build(params);

    assertTrue(p instanceof EqualsPredicate);
    EqualsPredicate eq = (EqualsPredicate) p;
    assertEquals(OccurrenceSearchParameter.BASIS_OF_RECORD, eq.getKey());
    assertEquals("PRESERVED_SPECIMEN", eq.getValue());

    // add a second country to check an OR is built
    params.put("BASIS_OF_RECORD", new String[] {"eq,OBSERVATION", "eq,PRESERVED_SPECIMEN"});
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
    params.put("LATITUDE", new String[] {"gt,10.00"}); // greater than
    p = pf.build(params);
    assertTrue(p instanceof ConjunctionPredicate);
    ConjunctionPredicate cq = (ConjunctionPredicate) p;
    assertEquals(2, cq.getPredicates().size());
    iter = cq.getPredicates().iterator();
    p = iter.next();
    assertTrue(p instanceof GreaterThanPredicate); // the OR'ed scientific names (tested above)
    GreaterThanPredicate gp = (GreaterThanPredicate) p;
    assertEquals(OccurrenceSearchParameter.LATITUDE, gp.getKey());
    assertEquals("10.00", gp.getValue());
    p = iter.next();
    assertTrue(p instanceof DisjunctionPredicate);
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
