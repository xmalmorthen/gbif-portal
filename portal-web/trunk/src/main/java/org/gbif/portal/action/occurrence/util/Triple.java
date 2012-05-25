/**
 * 
 */
package org.gbif.portal.action.occurrence.util;

import com.google.common.base.Objects;


/**
 * Simple immutable container (note package scope)
 */
class Triple {

  private final String subject;
  private final String predicate;
  private final String value;

  public Triple(String subject, String predicate, String value) {
    this.subject = subject;
    this.predicate = predicate;
    this.value = value;
  }

  @Override
  public boolean equals(Object object) {
    if (object instanceof Triple) {
      Triple that = (Triple) object;
      return Objects.equal(this.subject, that.subject) && Objects.equal(this.predicate, that.predicate)
        && Objects.equal(this.value, that.value);
    }
    return false;
  }

  public String getPredicate() {
    return predicate;
  }

  public String getSubject() {
    return subject;
  }

  public String getValue() {
    return value;
  }

  @Override
  public int hashCode() {
    return Objects.hashCode(subject, predicate, value);
  }

  @Override
  public String toString() {
    return Objects.toStringHelper(this).add("subject", subject).add("predicate", predicate).add("value", value)
      .toString();
  }

}
