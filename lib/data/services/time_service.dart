class TimeService {
  String getMealType() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Breakfast";
    if (hour < 17) return "Lunch";
    return "Dinner";
  }
}
