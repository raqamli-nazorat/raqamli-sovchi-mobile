enum CandidateType {
  groom('groom'),
  bride('bride'),
  representative('representative');

  const CandidateType(this.apiValue);

  final String apiValue;
}
