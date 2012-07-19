/**
 * 
 */
package org.gbif.portal.action.occurrence.util;

import com.google.common.base.Objects;


/**
 * Simple immutable container (note package scope)
 */
class Duplex {

  private final String subject;

  private final String predicate;

  public Duplex(String subject, String predicate) {
    this.subject = subject;
    this.predicate = predicate;
  }


  public Duplex(Triple source) {
    this.subject = source.getSubject();
    this.predicate = source.getPredicate();
  }

  @Override
  public boolean equals(Object object) {
    if (object instanceof Duplex) {
      Duplex that = (Duplex) object;
      return Objects.equal(this.subject, that.subject) && Objects.equal(this.predicate, that.predicate);
    }
    return false;
  }

  public String getPredicate() {
    return predicate;
  }

  public String getSubject() {
    return subject;
  }

  @Override
  public int hashCode() {
    return Objects.hashCode(subject, predicate);
  }

  @Override
  public String toString() {
    return Objects.toStringHelper(this).add("subject", subject).add("predicate", predicate).toString();
  }
}
