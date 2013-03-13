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
import org.gbif.api.model.occurrence.predicate.WithinPredicate;
import org.gbif.api.model.occurrence.search.OccurrenceSearchParameter;
import org.gbif.api.service.checklistbank.NameUsageService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseAction;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.LinkedList;
import java.util.Map;
import java.util.UUID;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * This class builds a human readable filter from a {@link org.gbif.api.model.occurrence.predicate.Predicate} hierarchy.
 * This class is not thread safe, create a new instance for every use if concurrent calls to {#humanFilter} is expected.
 * The IN predicate is not yet supported and you'll get an IllegalArgumentException.
 *
 * This builder only supports predicates that follow our search query parameters style with multiple values for the same
 * parameter being logically disjunct (OR) while different search parameters are logically combined (AND). Therefore
 * the {#humanFilter(Predicate p)} result is a map of OccurrenceSearchParameter (AND'ed) to a list of values (OR'ed).
 */
public class HumanFilterBuilder {

  private static final Logger LOG = LoggerFactory.getLogger(HumanFilterBuilder.class);
  private static final String EQUALS_OPERATOR = "";
  private static final String GREATER_THAN_OPERATOR = "&gt;";
  private static final String GREATER_THAN_EQUALS_OPERATOR = "&gt;=";
  private static final String LESS_THAN_OPERATOR = "&lt;";
  private static final String LESS_THAN_EQUALS_OPERATOR = "&lt;=";
  private static final String LIKE_OPERATOR = "~";

  private Map<OccurrenceSearchParameter, LinkedList<String>> filter;
  private enum State { ROOT, AND, OR };
  private State state;
  private OccurrenceSearchParameter lastParam;
  private final DatasetService datasetService;
  private final NameUsageService nameUsageService;
  private final BaseAction action;

  public HumanFilterBuilder(BaseAction action, DatasetService datasetService, NameUsageService nameUsageService) {
    this.datasetService = datasetService;
    this.nameUsageService = nameUsageService;
    this.action = action;
  }

  /**
   * @param p the predicate to convert
   * @return a list of anded parameters with multiple values to be combined with OR
   * @throws IllegalStateException if more complex predicates than the portal handles are supplied
   */
  public synchronized Map<OccurrenceSearchParameter, LinkedList<String>> humanFilter(Predicate p) {
    filter = Maps.newHashMap();
    state = State.ROOT;
    lastParam = null;
    visit(p);
    return filter;
  }

  private void visit(ConjunctionPredicate and) throws IllegalStateException {
    // ranges are allowed underneath root - try first
    try {
      visitRange(and);
      return;
    } catch (IllegalArgumentException e) {
      // must be a root AND
    }

    if (state != State.ROOT) {
      throw new IllegalStateException("AND must be a root predicate or a valid range");
    }
    state = State.AND;

    for (Predicate p : and.getPredicates()) {
      lastParam = null;
      visit(p);
    }
    state = State.ROOT;
  }

  private void visitRange(ConjunctionPredicate and){
    if (and.getPredicates().size() != 2){
      throw new IllegalArgumentException("no valid range");
    }
    GreaterThanOrEqualsPredicate lower = null;
    LessThanOrEqualsPredicate upper = null;
    for (Predicate p : and.getPredicates()) {
      if (p instanceof GreaterThanOrEqualsPredicate) {
        lower = (GreaterThanOrEqualsPredicate) p;
      } else if (p instanceof LessThanOrEqualsPredicate) {
        upper = (LessThanOrEqualsPredicate) p;
      }
    }
    if (lower == null || upper == null || lower.getKey() != upper.getKey()) {
      throw new IllegalArgumentException("no valid range");
    }
    addParamValue(lower.getKey(), "", lower.getValue() + "-" + upper.getValue());
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
    addParamValue(predicate.getKey(), EQUALS_OPERATOR, predicate.getValue());
  }

  private void visit(LikePredicate predicate) {
    addParamValue(predicate.getKey(), LIKE_OPERATOR, predicate.getValue());
  }

  private void visit(GreaterThanPredicate predicate) {
    addParamValue(predicate.getKey(), GREATER_THAN_OPERATOR, predicate.getValue());
  }

  private void visit(GreaterThanOrEqualsPredicate predicate) {
    addParamValue(predicate.getKey(), GREATER_THAN_EQUALS_OPERATOR, predicate.getValue());
  }

  private void visit(LessThanPredicate predicate) {
    addParamValue(predicate.getKey(), LESS_THAN_OPERATOR, predicate.getValue());
  }

  private void visit(LessThanOrEqualsPredicate predicate) {
    addParamValue(predicate.getKey(), LESS_THAN_EQUALS_OPERATOR, predicate.getValue());
  }

  private void visit(WithinPredicate within) {
    addParamValue(OccurrenceSearchParameter.GEOMETRY, "", within.getGeometry());
  }

  private void visit(InPredicate in) {
    for (String val : in.getValues()) {
      addParamValue(in.getKey(), EQUALS_OPERATOR, val);
    }
  }

  private void visit(NotPredicate not) throws IllegalStateException {
    if (not.getPredicate() instanceof SimplePredicate) {
      visit(not.getPredicate());
      SimplePredicate sp = (SimplePredicate) not.getPredicate();
      // now prefix the last value with NOT
      String notValue = "NOT (" + filter.get(sp.getKey()).removeLast() + ")";
      filter.get(sp.getKey()).add(notValue);

    } else {
      throw new IllegalArgumentException("NOT predicate must be followed by a simple predicate");
    }
  }

  private void addParamValue(OccurrenceSearchParameter param, String op, String value) {
    // verify that last param if existed was the same
    if (lastParam != null && param != lastParam) {
      throw new IllegalArgumentException("Mix of search params not supported");
    }

    if (!filter.containsKey(param)) {
      filter.put(param, Lists.<String>newLinkedList());
    }

    String humanValue;
    // lookup values
    switch (param) {
      case TAXON_KEY:
        humanValue = lookupTaxonKey(value);
        break;
      case DATASET_KEY:
        humanValue = lookupDatasetKey(value);
        break;
      case COUNTRY:
        humanValue = lookupCountryCode(value);
        break;
      case BASIS_OF_RECORD:
        humanValue = lookupBasisOfRecord(value);
        break;
      case MONTH:
        humanValue = lookupMonth(value);
        break;

      default:
        humanValue = value;
    }
    filter.get(param).add(op + humanValue);
    lastParam = param;
  }

  private String lookupBasisOfRecord(String value) {
    return action.getText("enum.basisofrecord."+value);
  }

  private String lookupCountryCode(String code) {
    Country c = Country.fromIsoCode(code);
    if (c != null) {
      return c.getTitle();
    }
    return code;
  }

  private String lookupMonth(String month) {
    return action.getText("enum.month."+month);
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
      throw new IllegalArgumentException("Unknown Predicate", e);
    }
    try {
      method.setAccessible(true);
      method.invoke(this, p);
    } catch (IllegalAccessException e) {
      LOG.error("This should never happen as we set accessible to true explicitly before. Probably a programming error", e);
      throw new RuntimeException("Programming error", e);
    } catch (InvocationTargetException e) {
      LOG.info("Exception thrown while building the Hive Download", e);
      throw new IllegalArgumentException(e);
    }
  }

}
