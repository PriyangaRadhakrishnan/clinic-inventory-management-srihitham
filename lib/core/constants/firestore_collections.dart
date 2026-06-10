class FirestoreCollections {
  // Core Collections
  static const String users = 'users';
  static const String patients = 'patients';
  static const String visits = 'visits';
  static const String prescriptions = 'prescriptions';
  static const String medicines = 'medicines';
  static const String purchaseBills = 'purchase_bills';
  static const String patientBills = 'patient_bills';
  static const String suppliers = 'suppliers';
  static const String settings = 'settings';
  static const String counters = 'counters';
  static const String notifications = 'notifications';
  static const String stockHistory = 'stock_history';

  // Optional helper paths
  static String patientVisitsPath(String patientId) =>
      'patients/$patientId/visits';

  static String visitPrescriptionsPath(
    String patientId,
    String visitId,
  ) =>
      'patients/$patientId/visits/$visitId/prescriptions';
}
