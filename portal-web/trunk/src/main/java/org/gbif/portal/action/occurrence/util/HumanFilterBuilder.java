/*
 * Copyright 2012 Global Biodiversity Information Facility (GBIF)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.gbif.portal.action.occurrence.util;

import org.gbif.api.model.occurrence.predicate.ConjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.DisjunctionPredicate;
import org.gbif.api.model.occurrence.predicate.EqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.GreaterThanPredicate;
import org.gbif.api.model.occurrence.predicate.InPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanOrEqualsPredicate;
import org.gbif.api.model.occurrence.predicate.LessThanPredicate;
import org.gbif.api.model.occurrence.predicate.LikePredicate;
import org.gbif.api.model.occurrence.predicate.NotPredicate;
import org.gbif.api.model.occurrence.predicate.Predicate;
import org.gbif.api.model.occurrence.predicate.SimplePredicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.service.checklistbank.NameUsageService;
import org.gbif.api.service.registry.DatasetService;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This class builds a human readable filter from a {@link org.gbif.api.model.occurrence.predicate.Predicate} hierarchy.
 * This class is not thread safe, create a new instance for every use if concurrent calls to {#humanFilter} is expected.
 */
public class HumanFilterBuilder {

  private static final Logger LOG = LoggerFactory.getLogger(HumanFilterBuilder.class);
  private static final String EQUALS_OPERATOR = "";
  private static final String GREATER_THAN_OPERATOR = " > ";
  private static final String GREATER_THAN_EQUALS_OPERATOR = " >= ";
  private static final String LESS_THAN_OPERATOR = " < ";
  private static final String LESS_THAN_EQUALS_OPERATOR = " <= ";
  private static final String LIKE_OPERATOR = " LIKE ";

  private Map<OccurrenceSearchParameter, List<String>> filter;
  private enum State { ROOT, AND, OR };
  private State state;
  private OccurrenceSearchParameter lastParam;
  private boolean lookupValues = true;

  private final DatasetService datasetService;
  private final NameUsageService nameUsageService;

  public HumanFilterBuilder(DatasetService datasetService, NameUsageService nameUsageService) {
    this.datasetService = datasetService;
    this.nameUsageService = nameUsageService;
  }

  /**
   * @param p the predicate to convert
   * @return a list of anded parameters with multiple values to be combined with OR
   * @throws IllegalStateException if more complex predicates than the portal handles are supplied
   */
  public Map<OccurrenceSearchParameter, List<String>> humanFilter(Predicate p) {
    return filter(p, true);
  }

  public String queryFilter(Predicate p) {
    StringBuilder b = new StringBuilder();
    Map<OccurrenceSearchParameter, List<String>> filter = filter(p, false);
    for (OccurrenceSearchParameter param : filter.keySet()) {
      for (String val : filter.get(param)) {
        b.append(param.name());
        b.append("=");
        b.append(URLEncoder.encode(val));
        b.append("&");
      }
    }
    return b.toString();
  }

  private Map<OccurrenceSearchParameter, List<String>> filter(Predicate p, boolean lookupValues) {
    this.lookupValues = lookupValues;
    filter = Maps.newHashMap();
    state = State.ROOT;
    lastParam = null;
    visit(p);
    return filter;
  }

  private void visit(ConjunctionPredicate and) throws IllegalStateException {
    if (state != State.ROOT) {
      throw new IllegalStateException("AND must be a root predicate");
    }
    state = State.AND;

    for (Predicate p : and.getPredicates()) {
      lastParam = null;
      visit(p);
    }
    state = State.ROOT;
  }

  private void visit(DisjunctionPredicate or) throws IllegalStateException {
    State oldState = state;
    if (state == State.OR) {
      throw new IllegalStateException("OR within OR filters not supported");
    }
    state = State.OR;

    for (Predicate p : or.getPredicates()) {
      visit(p);
    }
    state = oldState;
  }

  private void visit(EqualsPredicate predicate) {
    visitSimplePredicate(predicate, EQUALS_OPERATOR);
  }

  private void visit(LikePredicate predicate) {
    visitSimplePredicate(predicate, LIKE_OPERATOR);
  }

  private void visit(GreaterThanPredicate predicate) {
    visitSimplePredicate(predicate, GREATER_THAN_OPERATOR);
  }

  private void visit(GreaterThanOrEqualsPredicate predicate) {
    visitSimplePredicate(predicate, GREATER_THAN_EQUALS_OPERATOR);
  }

  private void visit(LessThanPredicate predicate) {
    visitSimplePredicate(predicate, LESS_THAN_OPERATOR);
  }

  private void visit(LessThanOrEqualsPredicate predicate) {
    visitSimplePredicate(predicate, LESS_THAN_EQUALS_OPERATOR);
  }

  private void visit(InPredicate predicate) {
    throw new IllegalStateException("IN predicate not supported");
  }

  private void visit(NotPredicate predicate) throws IllegalStateException {
    throw new IllegalStateException("NOT predicate not supported");
  }

  private void visitSimplePredicate(SimplePredicate predicate, String op) {
    // verify that last param if existed was the same
    if (lastParam != null && predicate.getKey() != lastParam) {
      throw new IllegalStateException("Mix of search params not supported");
    }
    if (!filter.containsKey(predicate.getKey())) {
      filter.put(predicate.getKey(), Lists.<String>newArrayList());
    }
    // lookup values
    String humanVal;
    if (lookupValues) {
      switch (predicate.getKey()) {
        case TAXON_KEY:
          humanVal = lookupTaxonKey(predicate.getValue());
          break;
        case DATASET_KEY:
          humanVal = lookupDatasetKey(predicate.getValue());
          break;
        default:
          humanVal = predicate.getValue();
      }
    } else {
      humanVal = predicate.getValue();
    }
    filter.get(predicate.getKey()).add(op + humanVal);
    lastParam = predicate.getKey();
  }

  private String lookupTaxonKey(String value) {
    try {
      return nameUsageService.get(Integer.parseInt(value), null).getScientificName();
    } catch (Exception e) {
      LOG.warn("Cannot get name for usage {}", value);
    }
    return value;
  }

  private String lookupDatasetKey(String value) {
    try {
      return datasetService.get(UUID.fromString(value)).getTitle();
    } catch (Exception e) {
      LOG.warn("Cannot get title for dataset {}", value);
    }
    return value;
  }

  private void visit(Predicate p) throws IllegalStateException {
    Method method = null;
    try {
      method = getClass().getDeclaredMethod("visit", new Class[] {p.getClass()});
    } catch (NoSuchMethodException e) {
      LOG.warn(
        "Visit method could not be found. That means a Predicate has been passed in that is unknown to this " + "class",
        e);
      throw new IllegalStateException("Unknown Predicate", e);
    }
    try {
      method.setAccessible(true);
      method.invoke(this, p);
    } catch (IllegalAccessException e) {
      LOG.error("This should never happen as we set accessible to true explicitly before. Probably a programming error", e);
      throw new RuntimeException("Programming error", e);
    } catch (InvocationTargetException e) {
      LOG.info("Exception thrown while building the Hive Download", e);
      throw new IllegalStateException(e);
    }
  }

}
