package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.vocabulary.Country;

import java.util.List;
import java.util.Map;

import com.google.common.collect.Lists;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class HumanFilterBuilderTest {

  @Test
  public void testHumanFilter() throws Exception {
    HumanFilterBuilder builder = new HumanFilterBuilder(null, null);
    Predicate p = new EqualsPredicate(OccurrenceSearchParameter.COUNTRY, Country.AFGHANISTAN.getIso2LetterCode());

    Map<OccurrenceSearchParameter, List<String>> x = builder.humanFilter(p);
    assertEquals(1, x.size());
    assertEquals(1, x.get(OccurrenceSearchParameter.COUNTRY).size());
    assertEquals("AF", x.get(OccurrenceSearchParameter.COUNTRY).get(0));

    List<Predicate> ors = Lists.newArrayList();
    ors.add(new EqualsPredicate(OccurrenceSearchParameter.YEAR, "2000"));
    ors.add(new EqualsPredicate(OccurrenceSearchParameter.YEAR, "2001"));
    ors.add(new EqualsPredicate(OccurrenceSearchParameter.YEAR, "2002"));
    DisjunctionPredicate or = new DisjunctionPredicate(ors);

    List<Predicate> ands = Lists.newArrayList(p, or);

    x = builder.humanFilter(new ConjunctionPredicate(ands));
    assertEquals(2, x.size());
    assertEquals(3, x.get(OccurrenceSearchParameter.YEAR).size());
  }
}
