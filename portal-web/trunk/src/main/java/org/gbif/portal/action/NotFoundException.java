package org.gbif.portal.action;

/**
 * Exception to throw in struts actions when a resource could not be found.
 * This allows simple mapping of an exception to a 404 page and to throw those exceptions in any place of the code
 * - instead of returning a resultname string.
 */
public class NotFoundException extends RuntimeException{

  public NotFoundException() {
  }

  public NotFoundException(String s) {
    super(s);
  }

  public NotFoundException(String s, Throwable throwable) {
    super(s, throwable);
  }

  public NotFoundException(Throwable throwable) {
    super(throwable);
  }
}
