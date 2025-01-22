class ErrorCode {
  // AUTH
  static const String USER_ACCOUNT_IS_LOCKED = "AU_00001";
  static const String OLD_PASSWORD_IS_INCORRECT = "AU_00002"; // Added missing code

  // REGISTRATION_REQUEST
  static const String REGISTRATION_REQUEST_NOT_FOUND = "RR_00001";

  // TOURPACKAGE
  static const String TOUR_PACKAGE_ALREADY_EXISTS = "TP_00001";
  static const String TOUR_PACKAGE_NOT_FOUND = "TP_00002";

  // TOUR_INSTANCE
  static const String TOUR_INSTANCE_NOT_FOUND = "TI_00001";

  // TOUR_ASSIGNMENT
  static const String TOUR_ASSIGNMENT_NOT_FOUND = "TA_00001";

  // ITEM
  static const String ITEM_NOT_FOUND = "IT_00001";

  // ASSIGNMENT_ITEM
  static const String ASSIGNMENT_ITEM_NOT_FOUND = "IT_00002"; // Updated to be unique

  // PASSENGER
  static const String PASSENGER_NOT_FOUND = "PA_00001";

  // RIDER
  static const String RIDER_NOT_FOUND = "RD_00001";
  static const String TOUR_GUIDE_NOT_FOUND = "RD_00002";
  static const String MUST_HAVE_ROLE_RIDER = "RD_00003";
  static const String RIDER_IN_OTHER_TOUR = "RD_00004";
  static const String RIDER_IS_NOT_READY = "RD_00005";

  // USER
  static const String USER_NOT_FOUND = "U_00001";

  // USER_INFORMATION
  static const String CCCD_ALREADY_EXISTS = "UI_00001";
  static const String GPLX_ALREADY_EXISTS = "UI_00002";
  static const String EMAIL_ALREADY_EXISTS = "UI_00003";
  static const String PHONE_NUMBER_ALREADY_EXISTS = "UI_00004";

  // ROLE
  static const String MUST_HAVE_ADMIN_ROLE = "RL_00001";
  static const String MUST_HAVE_MANAGER_ROLE = "RL_00002";
  static const String MUST_HAVE_TOUR_GUIDE_ROLE = "RL_00003";
  static const String MUST_HAVE_EASY_RIDER_ROLE = "RL_00004";

  // ACTION
  static const String CAN_NOT_DELETE = "AC_00001";
}

class ErrorMessage {
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case ErrorCode.USER_ACCOUNT_IS_LOCKED:
        return "Tài khoản người dùng bị khóa.";
      case ErrorCode.OLD_PASSWORD_IS_INCORRECT: // Added missing message
        return "Mật khẩu cũ không đúng.";
      case ErrorCode.REGISTRATION_REQUEST_NOT_FOUND:
        return "Không tìm thấy yêu cầu đăng ký.";
      case ErrorCode.TOUR_PACKAGE_ALREADY_EXISTS:
        return "Gói tour đã tồn tại.";
      case ErrorCode.TOUR_PACKAGE_NOT_FOUND:
        return "Không tìm thấy gói tour.";
      case ErrorCode.TOUR_INSTANCE_NOT_FOUND:
        return "Không tìm thấy phiên tour.";
      case ErrorCode.TOUR_ASSIGNMENT_NOT_FOUND:
        return "Không tìm thấy phân công tour.";
      case ErrorCode.ITEM_NOT_FOUND:
        return "Không tìm thấy mục.";
      case ErrorCode.ASSIGNMENT_ITEM_NOT_FOUND:
        return "Không tìm thấy mục phân công.";
      case ErrorCode.PASSENGER_NOT_FOUND:
        return "Không tìm thấy hành khách.";
      case ErrorCode.RIDER_NOT_FOUND:
        return "Không tìm thấy người lái.";
      case ErrorCode.TOUR_GUIDE_NOT_FOUND:
        return "Không tìm thấy hướng dẫn viên.";
      case ErrorCode.MUST_HAVE_ROLE_RIDER:
        return "Phải có vai trò người lái.";
      case ErrorCode.RIDER_IN_OTHER_TOUR:
        return "Người lái đang ở tour khác.";
      case ErrorCode.RIDER_IS_NOT_READY:
        return "Người lái chưa sẵn sàng.";
      case ErrorCode.USER_NOT_FOUND:
        return "Không tìm thấy người dùng.";
      case ErrorCode.CCCD_ALREADY_EXISTS:
        return "CCCD đã tồn tại.";
      case ErrorCode.GPLX_ALREADY_EXISTS:
        return "GPLX đã tồn tại.";
      case ErrorCode.EMAIL_ALREADY_EXISTS:
        return "Email đã tồn tại.";
      case ErrorCode.PHONE_NUMBER_ALREADY_EXISTS:
        return "Số điện thoại đã tồn tại.";
      case ErrorCode.MUST_HAVE_ADMIN_ROLE:
        return "Phải có vai trò quản trị viên.";
      case ErrorCode.MUST_HAVE_MANAGER_ROLE:
        return "Phải có vai trò quản lý.";
      case ErrorCode.MUST_HAVE_TOUR_GUIDE_ROLE:
        return "Phải có vai trò hướng dẫn viên.";
      case ErrorCode.MUST_HAVE_EASY_RIDER_ROLE:
        return "Phải có vai trò easy rider.";
      case ErrorCode.CAN_NOT_DELETE:
        return "Không thể xóa.";
      default:
        return "Lỗi không xác định.";
    }
  }
}
