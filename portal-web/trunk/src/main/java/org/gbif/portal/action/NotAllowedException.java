package org.gbif.portal.action;

/**
 * Exception to throw in struts actions when a url requires authorisation which the current user doesnt have.
 */
public class NotAllowedException extends RuntimeException{

  public NotAllowedException() {
  }

  public NotAllowedException(String s) {
    super(s);
  }

  public NotAllowedException(String s, Throwable throwable) {
    super(s, throwable);
  }

  public NotAllowedException(Throwable throwable) {
    super(throwable);
  }
}
