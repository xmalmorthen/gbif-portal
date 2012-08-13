package org.gbif.portal.action.occurrence.util.search;

import org.gbif.occurrencestore.download.api.model.predicate.CompoundPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.ConjunctionPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.DisjunctionPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.EqualsPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.GreaterThanPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.LessThanPredicate;
import org.gbif.occurrencestore.download.api.model.predicate.Predicate;
import org.gbif.occurrencestore.download.api.model.predicate.SimplePredicate;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Iterator;

import com.google.common.collect.HashMultimap;
import com.google.common.collect.Multimap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WsSearchVisitor {

  private static final Logger LOG = LoggerFactory.getLogger(WsSearchVisitor.class);

  // Value place holder
  private static final String V_PLACE_HOLDER = "\\$v";

  private static final String GREATER_THAN_OPERATOR = "[* TO " + V_PLACE_HOLDER + "]";
  private static final String LESS_THAN_OPERATOR = "[" + V_PLACE_HOLDER + " TO *]";

  private Multimap<String, String> params;

  /**
   * Translates a valid {@link Predicate} object into a
   * string that can be used as the query string for a occurrence search request.
   * 
   * @param download to translate
   * @return WHERE clause
   */
  public Multimap<String, String> getWsSearchParameters(Predicate predicate) throws QueryBuildingException {
    params = HashMultimap.create();
    if (predicate != null) {
      visit(predicate);
    }
    return params;
  }

  public void visit(ConjunctionPredicate predicate) throws QueryBuildingException {
    visitCompoundPredicate(predicate);
  }

  public void visit(DisjunctionPredicate predicate) throws QueryBuildingException {
    visitCompoundPredicate(predicate);
  }

  public void visit(EqualsPredicate predicate) {
    params.put(predicate.getKey(), predicate.getValue());
  }

  public void visit(GreaterThanPredicate predicate) {
    visitPatternPredicate(predicate, GREATER_THAN_OPERATOR);
  }

  public void visit(LessThanPredicate predicate) {
    visitPatternPredicate(predicate, LESS_THAN_OPERATOR);
  }

  /**
   * Builds a list of predicates joined by 'op' statements.
   * The final statement will look like this:
   * 
   * <pre>
   * ((predicate) op (predicate) ... op (predicate))
   * </pre>
   */
  public void visitCompoundPredicate(CompoundPredicate predicate) throws QueryBuildingException {
    Iterator<Predicate> iterator = predicate.getPredicates().iterator();
    while (iterator.hasNext()) {
      Predicate subPredicate = iterator.next();
      visit(subPredicate);
    }
  }

  public void visitPatternPredicate(SimplePredicate predicate, String op) {
    params.put(predicate.getKey(), op.replaceAll(V_PLACE_HOLDER, predicate.getValue()));
  }

  private void visit(Object object) throws QueryBuildingException {
    Method method = null;
    try {
      method = getClass().getMethod("visit", new Class[] {object.getClass()});
    } catch (NoSuchMethodException e) {
      LOG
        .warn(
          "Visit method could not be found. That means a Predicate has been passed in that is unknown to this "
            + "class",
          e);
      throw new IllegalArgumentException("Unknown Predicate", e);
    }
    try {
      method.invoke(this, object);
    } catch (IllegalAccessException e) {
      LOG.error("This should never happen as all our methods are public and missing methods should have been caught "
        + "before. Probably a programming error", e);
      throw new RuntimeException("Programming error", e);
    } catch (InvocationTargetException e) {
      LOG.info("Exception thrown while building the Hive Download", e);
      throw new QueryBuildingException(e);
    }
  }

}
