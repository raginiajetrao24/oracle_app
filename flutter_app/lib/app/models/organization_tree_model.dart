class OrgTreeVersion {
  final String name;
  final String code;
  final String structure;
  final String effectiveStart;
  final String effectiveEnd;

  const OrgTreeVersion({
    required this.name,
    required this.code,
    required this.structure,
    required this.effectiveStart,
    this.effectiveEnd = '',
  });

  String get effectiveDateRange {
    final end = effectiveEnd.isEmpty ? 'Present' : effectiveEnd;
    return '$effectiveStart – $end';
  }
}

class OrgTree {
  final int id;
  final String name;
  final String code;
  final String set;
  final String structure;
  final String effectiveStart;
  final String effectiveEnd;
  final List<OrgTreeVersion> versions;

  const OrgTree({
    required this.id,
    required this.name,
    required this.code,
    required this.set,
    required this.structure,
    this.effectiveStart = '',
    this.effectiveEnd = '',
    this.versions = const [],
  });

  bool get hasVersions => versions.isNotEmpty;
}

final List<OrgTree> sampleOrgTrees = [
  OrgTree(
    id: 1,
    name: 'Recruiting Organization Tree',
    code: 'ORC_ORG_TRE',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
    versions: [
      OrgTreeVersion(
        name: 'Recruiting Tree - version 1',
        code: 'ORC_ORG_TRE',
        structure: 'PER_ORG_TREE_STRUCTI',
        effectiveStart: '1/1/17',
      ),
      OrgTreeVersion(
        name: 'Recruiting Tree - version 2',
        code: 'ORC_ORG_TRE',
        structure: 'PER_ORG_TREE_STRUCTI',
        effectiveStart: '1/1/17',
      ),
    ],
  ),
  OrgTree(
    id: 2,
    name: 'OTL_TREE',
    code: 'OTL',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
  ),
  OrgTree(
    id: 3,
    name: 'Project Organization Hierarchy',
    code: 'PRJORGHRY',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
    versions: [
      OrgTreeVersion(
        name: 'Project Organization Hierarchy V1',
        code: 'PRJORGHRY',
        structure: 'PER_ORG_TREE_STRUCTI',
        effectiveStart: '1/1/01',
      ),
    ],
  ),
  OrgTree(
    id: 4,
    name: 'OS Tree',
    code: 'OS Tree',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
    versions: [
      OrgTreeVersion(
        name: 'OS Tree',
        code: 'OS Tree',
        structure: 'PER_ORG_TREE_STRUCTI',
        effectiveStart: '1/1/51',
      ),
    ],
  ),
  OrgTree(
    id: 5,
    name: 'SD Organization Tree',
    code: 'SD_ORG_TREE',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
  ),
  OrgTree(
    id: 6,
    name: 'Supremo Group Project Organization',
    code: 'SGPRJORG',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
  ),
  OrgTree(
    id: 7,
    name: 'TD Organization Trees',
    code: 'TD_ORG_TREE',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
    versions: [
      OrgTreeVersion(
        name: 'TD Organization Trees V1',
        code: 'TD_ORG_TREE',
        structure: 'PER_ORG_TREE_STRUCTI',
        effectiveStart: '1/1/51',
      ),
    ],
  ),
  OrgTree(
    id: 8,
    name: 'UGRP Org',
    code: 'UGRP',
    set: 'Common Set',
    structure: 'PER_ORG_TREE_STRUCTI',
  ),
];
