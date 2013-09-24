package org.gbif.portal.action.country;

import org.gbif.api.service.registry.NodeService;
import org.gbif.api.vocabulary.Country;
import org.gbif.portal.action.BaseAction;
import org.gbif.portal.config.ContinentCountryMap;

import java.util.List;
import java.util.Set;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import com.google.inject.Inject;

public class HomeAction extends BaseAction {

  /**
   * Utility to order countries by title which is different to the toString() of the enum.
   */
  private static class TitleOrdering extends Ordering<Country> {
    public static TitleOrdering INSTANCE = new TitleOrdering();
    private TitleOrdering() {
    }
    @Override
    public int compare(Country left, Country right) {
      return left.getTitle().compareTo(right.getTitle());
    }
  }

  /**
   * Ensure we are ordered by title, removing noise.
   */
  private static List<Country> countries;
  static {
    // clean up the country list to something displayable
    List<Country> copy = Lists.newArrayList(Country.values());
    // remove noise
    copy.remove(Country.UNKNOWN);
    copy.remove(Country.USER_DEFINED);
    copy.remove(Country.INTERNATIONAL_WATERS);
    // sort on the title (knowing that the enumeration does things with Chinese Tapei etc
    countries = ImmutableList.copyOf(TitleOrdering.INSTANCE.sortedCopy(Lists.newArrayList(copy)));
  }


  private Set<Country> activeNodes;
  @Inject
  private NodeService nodeService;
  @Inject
  private ContinentCountryMap continentMap;

  @Override
  public String execute() throws Exception {
    activeNodes = Sets.newHashSet(nodeService.listActiveCountries());
    return SUCCESS;
  }

  public Set<Country> getActiveNodes() {
    return activeNodes;
  }

  public List<Country> getCountries() {
    return countries;
  }
}
