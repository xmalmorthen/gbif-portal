package org.gbif.portal.config;

/**
 * Inidcates that the application configuration is incorrect
 * 
 * @author timrobertson
 */
public class ConfigurationException extends RuntimeException {

  public ConfigurationException(String message) {
    super(message);
  }
}
