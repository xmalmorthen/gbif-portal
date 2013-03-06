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
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseAction;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import static org.junit.Assert.assertEquals;

@RunWith(MockitoJUnitRunner.class)
public class HumanFilterBuilderTest {
  @Mock
  private BaseAction action;

  @Test
  public void testHumanFilter() throws Exception {
    HumanFilterBuilder builder = new HumanFilterBuilder(action, null, null);

    Predicate p = new EqualsPredicate(OccurrenceSearchParameter.COUNTRY, Country.AFGHANISTAN.getIso2LetterCode());

    Map<OccurrenceSearchParameter, LinkedList<String>> x = builder.humanFilter(p);
    assertEquals(1, x.size());
    assertEquals(1, x.get(OccurrenceSearchParameter.COUNTRY).size());
    assertEquals("Afghanistan", x.get(OccurrenceSearchParameter.COUNTRY).get(0));

    List<Predicate> ors = Lists.newArrayList();
    ors.add(new EqualsPredicate(OccurrenceSearchParameter.YEAR, "2000"));
    ors.add(new EqualsPredicate(OccurrenceSearchParameter.YEAR, "2001"));
    ors.add(new LessThanOrEqualsPredicate(OccurrenceSearchParameter.YEAR, "1760"));
    DisjunctionPredicate or = new DisjunctionPredicate(ors);

    List<Predicate> ands = Lists.newArrayList(p, or);

    x = builder.humanFilter(new ConjunctionPredicate(ands));
    assertEquals(2, x.size());
    assertEquals(3, x.get(OccurrenceSearchParameter.YEAR).size());
    assertEquals("&lt;=1760", x.get(OccurrenceSearchParameter.YEAR).getLast());

    NotPredicate noBirds = new NotPredicate(new EqualsPredicate(OccurrenceSearchParameter.TAXON_KEY, "212"));
    ands.add(noBirds);

    x = builder.humanFilter(new ConjunctionPredicate(ands));
    assertEquals(3, x.size());
    assertEquals(3, x.get(OccurrenceSearchParameter.YEAR).size());
    assertEquals(1, x.get(OccurrenceSearchParameter.TAXON_KEY).size());
    assertEquals("NOT (212)", x.get(OccurrenceSearchParameter.TAXON_KEY).getLast());
  }

  @Test
  public void testPolygon() throws Exception {
    HumanFilterBuilder builder = new HumanFilterBuilder(action, null, null);
    final String wkt = "POLYGON ((30 10, 10 20, 20 40, 40 40, 30 10))";
    Map<OccurrenceSearchParameter, LinkedList<String>> x = builder.humanFilter(new ConjunctionPredicate(Lists.<Predicate>newArrayList(new WithinPredicate(wkt))));
    assertEquals(1, x.size());
    assertEquals(1, x.get(OccurrenceSearchParameter.GEOMETRY).size());
    assertEquals(wkt, x.get(OccurrenceSearchParameter.GEOMETRY).getLast());
  }

  @Test
  public void testRange() throws Exception {
    HumanFilterBuilder builder = new HumanFilterBuilder(action, null, null);

    List<Predicate> rangeAnd = Lists.newArrayList();
    rangeAnd.add(new GreaterThanOrEqualsPredicate(OccurrenceSearchParameter.YEAR, "2000"));
    rangeAnd.add(new LessThanOrEqualsPredicate(OccurrenceSearchParameter.YEAR, "2011"));
    Predicate range = new ConjunctionPredicate(rangeAnd);

    Map<OccurrenceSearchParameter, LinkedList<String>> x = builder.humanFilter(range);
    assertEquals(1, x.size());
    assertEquals(1, x.get(OccurrenceSearchParameter.YEAR).size());

    // now test with other filters combined
    Predicate eq = new EqualsPredicate(OccurrenceSearchParameter.TAXON_KEY, "212");
    x = builder.humanFilter(new ConjunctionPredicate(Lists.newArrayList(eq, range)));
    assertEquals(2, x.size());
    assertEquals(1, x.get(OccurrenceSearchParameter.TAXON_KEY).size());
    assertEquals(1, x.get(OccurrenceSearchParameter.YEAR).size());
  }

}
