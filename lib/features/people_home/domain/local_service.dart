String decideStudyWork(String placeOfWork, String placeOfEdu) {
  if (placeOfWork.isEmpty && placeOfEdu.isEmpty) {
    return "N/A";
  } else if (placeOfWork.isEmpty) {
    return placeOfEdu;
  }
  return placeOfWork;
}
