package org.gbif.portal.action.species;

import org.gbif.api.model.checklistbank.TypeSpecimen;
import org.gbif.api.service.checklistbank.TypeSpecimenService;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import com.google.common.base.Strings;
import com.google.common.collect.Sets;
import com.google.inject.Inject;
import org.apache.commons.lang3.StringUtils;


public class TypesAction extends SeeMoreAction<TypeSpecimen> {
  private static final Set<String> TYPE_NAME_STATUS = Sets.newHashSet("typegenus","typespecies","genus","species");
  @Inject
  public TypesAction(TypeSpecimenService service) {
    super(service);
  }

  @Override
  public String execute() {
    super.execute();
    TypesAction.removeInvalidTypes(getPage().getResults());
    return SUCCESS;
  }

  /**
   * Iterates over the types in a usage and remove the ones which have bad content - mainly from wikipedia.
   * See http://dev.gbif.org/issues/browse/POR-409
   */
  public static void removeInvalidTypes(List<TypeSpecimen> types){
    Iterator<TypeSpecimen> iter = types.iterator();
    while (iter.hasNext()) {
      TypeSpecimen ts = iter.next();
      String status = StringUtils.deleteWhitespace(ts.getTypeStatus()).toLowerCase();
      if (ts == null || (Strings.isNullOrEmpty(ts.getScientificName()) && TYPE_NAME_STATUS.contains(status))) {
        iter.remove();
      }
    }
  }
}