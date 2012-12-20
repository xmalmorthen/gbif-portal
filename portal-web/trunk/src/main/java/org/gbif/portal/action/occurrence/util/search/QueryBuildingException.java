/*
 * Copyright 2012 Global Biodiversity Information Facility (GBIF)
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.gbif.portal.action.occurrence.util.search;

/**
 * Wraps an Exception thrown during processing a {@link org.gbif.api.model.occurrence.Download}.
 */
public class QueryBuildingException extends IllegalArgumentException {

  private static final long serialVersionUID = 0;
  private final Object predicate;
  /**
   * Creates a new instance with the given cause.
   * 
   * @param cause wrapped cause
   */
  public QueryBuildingException(Object predicate, Throwable cause) {
    super(cause);
    this.predicate = predicate;
  }

  public Object getPredicate() {
    return predicate;
  }
}