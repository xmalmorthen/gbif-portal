package org.gbif.portal.model;


import org.gbif.api.util.VocabularyUtils;

import java.util.EnumSet;

import javax.servlet.http.HttpServletRequest;

/**
 * Class that represents the configuration for the HTML table shown in the occurrence search page.
 */
public class OccurrenceTable {

  /**
   * Enum that represents the visible columns in the occurrence page.
   */
  public static enum OccurrenceColumn {
    SUMMARY, LOCATION, BASIS_OF_RECORD, DATE;
  }

  /**
   * Enum that represents the visible information of the summary column in the occurrence page.
   */
  public static enum OccurrenceSummaryField {
    OCCURRENCE_KEY, CATALOG_NUMBER, COLLECTION_CODE, COLLECTOR_NAME, INSTITUTION, SCIENTIFIC_NAME, DATASET;
  }

  // Default list of summary fields
  private static EnumSet<OccurrenceSummaryField> defaulSummaryFields = EnumSet.of(
    OccurrenceSummaryField.OCCURRENCE_KEY,
    OccurrenceSummaryField.CATALOG_NUMBER, OccurrenceSummaryField.SCIENTIFIC_NAME,
    OccurrenceSummaryField.DATASET);


  // Columns HTTP parameter
  private static final String COLUMNS_PARAM = "columns";

  // summary fields HTTP parameter
  private static final String SUMMARY_FIELDS_PARAM = "summary";

  private final EnumSet<OccurrenceColumn> columns;

  private final EnumSet<OccurrenceSummaryField> summaryColumn;


  /**
   * Default constructor. Creates a instance containing the default elements.
   */
  public OccurrenceTable() {
    this.columns = EnumSet.allOf(OccurrenceColumn.class);
    this.summaryColumn = EnumSet.copyOf(defaulSummaryFields);
  }


  /**
   * Creates an instance container the columns and summary fields set in the request parameter.
   */
  public OccurrenceTable(HttpServletRequest request) {
    this.columns = retrieveColumns(request);
    this.summaryColumn = retrieveSummaryFields(request);
  }

  /**
   * Holds the list of visible columns, the default value is OccurrenceColumn.values(). Values can be set by setting the
   * parameter 'columns'.
   */
  public EnumSet<OccurrenceColumn> getColumns() {
    return columns;
  }


  /**
   * Gets the html.table.td colspan value for the summary column.
   */
  public int getSummaryColspan() {
    // +1 because summary column is always shown
    return columns.size() + 1;
  }

  /**
   * Summary column contains basic occurrence information, its default values are OCCURRENCE_KEY, CATALOGUE_NUMBER,
   * SCIENTIFIC_NAME, INSTITUTION.
   */
  public EnumSet<OccurrenceSummaryField> getSummaryColumn() {
    return summaryColumn;
  }

  /**
   * Checks if the column parameter exists in the list of columns.
   */
  public boolean hasColumn(OccurrenceColumn column) {
    return columns.contains(column);
  }


  /**
   * Checks if the column name parameter exists in the list of columns.
   */
  public boolean hasColumn(String column) {
    return columns.contains(OccurrenceColumn.valueOf(column));
  }

  /**
   * Checks if the field parameter exists in the list of summary fields.
   */
  public boolean hasSummaryField(OccurrenceSummaryField field) {
    return summaryColumn.contains(field);
  }

  /**
   * Checks if the column name parameter exists in the list of summary fields.
   */
  public boolean hasSummaryField(String column) {
    return summaryColumn.contains(OccurrenceSummaryField.valueOf(column));
  }


  /**
   * Retrieve the columns from the request parameter.
   * The default fields are returned if no value is gotten from the request.
   */
  private EnumSet<OccurrenceColumn> retrieveColumns(HttpServletRequest request) {
    EnumSet<OccurrenceColumn> columns = retrieveEnumParams(request, OccurrenceColumn.class, COLUMNS_PARAM);
    if (columns.isEmpty()) {
      columns = EnumSet.allOf(OccurrenceColumn.class);
    }
    return columns;
  }


  /**
   * Retrieve an EnumSet containing a list of Enum literals if type T that can be obtained from the request parameter
   * paramName.
   */
  private <T extends Enum<T>> EnumSet<T> retrieveEnumParams(HttpServletRequest request, Class<T> enumClass,
    String paramName) {
    EnumSet<T> columns = EnumSet.noneOf(enumClass);
    final String values[] = request.getParameterValues(paramName);
    if (values != null) {
      for (String paramValue : values) {
        for (String value : paramValue.split(",")) {
          Enum<?> enumLiteral = VocabularyUtils.lookupEnum(value, enumClass);
          if (enumLiteral != null) {
            columns.add((T) enumLiteral);
          }
        }
      }
    }
    return columns;
  }

  /**
   * Retrieve the summary fields from the request.
   * The default fields are returned if no value is gotten from the request.
   */
  private EnumSet<OccurrenceSummaryField> retrieveSummaryFields(HttpServletRequest request) {
    EnumSet<OccurrenceSummaryField> fields =
      retrieveEnumParams(request, OccurrenceSummaryField.class, SUMMARY_FIELDS_PARAM);
    if (fields.isEmpty()) {
      fields.addAll(defaulSummaryFields);
    }
    return fields;
  }

}
