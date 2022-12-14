// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Storyrs`
  String get storyrs {
    return Intl.message(
      'Storyrs',
      name: 'storyrs',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Storyrs`
  String get welcomeTitle {
    return Intl.message(
      'Welcome to Storyrs',
      name: 'welcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Create a new Storyrs project`
  String get createNewProject {
    return Intl.message(
      'Create a new Storyrs project',
      name: 'createNewProject',
      desc: '',
      args: [],
    );
  }

  /// `Start a new project from a template.`
  String get createNewProjectSubTitle {
    return Intl.message(
      'Start a new project from a template.',
      name: 'createNewProjectSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Open the Getting Started guide`
  String get openGuide {
    return Intl.message(
      'Open the Getting Started guide',
      name: 'openGuide',
      desc: '',
      args: [],
    );
  }

  /// `Learn about Storyrs features.`
  String get learnFeatures {
    return Intl.message(
      'Learn about Storyrs features.',
      name: 'learnFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Visit the Storyrs website`
  String get visitWebsite {
    return Intl.message(
      'Visit the Storyrs website',
      name: 'visitWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Sample files, video tutorials, and more...`
  String get sampleFile {
    return Intl.message(
      'Sample files, video tutorials, and more...',
      name: 'sampleFile',
      desc: '',
      args: [],
    );
  }

  /// `Show this window when Storyrs launches`
  String get showLaunchesWindow {
    return Intl.message(
      'Show this window when Storyrs launches',
      name: 'showLaunchesWindow',
      desc: '',
      args: [],
    );
  }

  /// `last updated at`
  String get lastUpdatedAt {
    return Intl.message(
      'last updated at',
      name: 'lastUpdatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Open Another Project...`
  String get openAnotherProject {
    return Intl.message(
      'Open Another Project...',
      name: 'openAnotherProject',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get openFileConfirmButtonText {
    return Intl.message(
      'Open',
      name: 'openFileConfirmButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Search Project`
  String get searchProject {
    return Intl.message(
      'Search Project',
      name: 'searchProject',
      desc: '',
      args: [],
    );
  }

  /// `About Storyrs`
  String get aboutStoryrs {
    return Intl.message(
      'About Storyrs',
      name: 'aboutStoryrs',
      desc: '',
      args: [],
    );
  }

  /// `Preferences...`
  String get preference {
    return Intl.message(
      'Preferences...',
      name: 'preference',
      desc: '',
      args: [],
    );
  }

  /// `Hide Storyrs`
  String get hide {
    return Intl.message(
      'Hide Storyrs',
      name: 'hide',
      desc: '',
      args: [],
    );
  }

  /// `Hide Others`
  String get hideOthers {
    return Intl.message(
      'Hide Others',
      name: 'hideOthers',
      desc: '',
      args: [],
    );
  }

  /// `Show All`
  String get showAll {
    return Intl.message(
      'Show All',
      name: 'showAll',
      desc: '',
      args: [],
    );
  }

  /// `Quit Storyrs`
  String get quit {
    return Intl.message(
      'Quit Storyrs',
      name: 'quit',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newFile {
    return Intl.message(
      'New',
      name: 'newFile',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Open recent...`
  String get openRecent {
    return Intl.message(
      'Open recent...',
      name: 'openRecent',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get closeFile {
    return Intl.message(
      'Close',
      name: 'closeFile',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveFile {
    return Intl.message(
      'Save',
      name: 'saveFile',
      desc: '',
      args: [],
    );
  }

  /// `Import...`
  String get importFile {
    return Intl.message(
      'Import...',
      name: 'importFile',
      desc: '',
      args: [],
    );
  }

  /// `Export...`
  String get exportFile {
    return Intl.message(
      'Export...',
      name: 'exportFile',
      desc: '',
      args: [],
    );
  }

  /// `Print...`
  String get printFile {
    return Intl.message(
      'Print...',
      name: 'printFile',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message(
      'Undo',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `Redo`
  String get redo {
    return Intl.message(
      'Redo',
      name: 'redo',
      desc: '',
      args: [],
    );
  }

  /// `Cut`
  String get cut {
    return Intl.message(
      'Cut',
      name: 'cut',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Paste`
  String get paste {
    return Intl.message(
      'Paste',
      name: 'paste',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get selectAll {
    return Intl.message(
      'Select All',
      name: 'selectAll',
      desc: '',
      args: [],
    );
  }

  /// `Insert`
  String get insert {
    return Intl.message(
      'Insert',
      name: 'insert',
      desc: '',
      args: [],
    );
  }

  /// `Find`
  String get find {
    return Intl.message(
      'Find',
      name: 'find',
      desc: '',
      args: [],
    );
  }

  /// `Find...`
  String get find2 {
    return Intl.message(
      'Find...',
      name: 'find2',
      desc: '',
      args: [],
    );
  }

  /// `Find and Replace...`
  String get replace {
    return Intl.message(
      'Find and Replace...',
      name: 'replace',
      desc: '',
      args: [],
    );
  }

  /// `Format`
  String get format {
    return Intl.message(
      'Format',
      name: 'format',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Window`
  String get window {
    return Intl.message(
      'Window',
      name: 'window',
      desc: '',
      args: [],
    );
  }

  /// `Minimize`
  String get minimize {
    return Intl.message(
      'Minimize',
      name: 'minimize',
      desc: '',
      args: [],
    );
  }

  /// `Zoom`
  String get zoom {
    return Intl.message(
      'Zoom',
      name: 'zoom',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Storyrs Help`
  String get help2 {
    return Intl.message(
      'Storyrs Help',
      name: 'help2',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Storyrs`
  String get welcome {
    return Intl.message(
      'Welcome to Storyrs',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
