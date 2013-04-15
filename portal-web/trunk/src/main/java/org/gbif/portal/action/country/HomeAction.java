package org.gbif.portal.action.country;

import org.gbif.api.vocabulary.Country;

import java.util.List;

import com.google.common.collect.Lists;

public class HomeAction extends org.gbif.portal.action.BaseAction {

  private static List<Country> countries = Lists.newArrayList(Country.values());

  public static List<Country> getCountries() {
    return countries;
  }
}
