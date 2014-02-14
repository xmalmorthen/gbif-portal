<?php

function gbif_catalogue_settings_form() {
  $form['gbif_catalogue'] = array(
    '#type' => 'fieldset',
    '#title' => t('Settings management.'),
    '#description' => '<p>' . t('Settings and triggers at the development phase.') . '</p>',
  );
  $form['gbif_catalogue']['vocabulary_create'] = array(
    '#type' => 'submit',
    '#value' => t('Install vocabulary'),
    '#prefix' => '<div id="install-div">',
    '#suffix' => '<div id="install-status-wrapper"></div></div>',
    '#ajax' => array(
      'callback' => 'gbif_catalogue_vocabularies_create',
      'wrapper' => 'install-status-wrapper',
      'effect' => 'fade',
    ),
  );
  $form['gbif_catalogue']['vocabulary_delete'] = array(
    '#type' => 'submit',
    '#value' => t('Delete vocabulary'),
    '#prefix' => '<div id="delete-div">',
    '#suffix' => '<div id="delete-status-wrapper"></div></div>',
    '#ajax' => array(
      'callback' => 'gbif_catalogue_vocabularies_delete',
      'wrapper' => 'delete-status-wrapper',
      'effect' => 'fade',
    ),
  );
  return system_settings_form($form);
}

function gbif_catalogue_settings_form_submit() {
  
}