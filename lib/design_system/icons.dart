import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'color_schemes.dart';

/// App icon system using Font Awesome icons
/// Provides consistent icon usage throughout the app
class AppIcons {
  // Navigation icons
  static const IconData home = FontAwesomeIcons.house;
  static const IconData orders = FontAwesomeIcons.list;
  static const IconData branches = FontAwesomeIcons.building;
  static const IconData staff = FontAwesomeIcons.users;
  static const IconData analytics = FontAwesomeIcons.chartLine;
  static const IconData settings = FontAwesomeIcons.gear;

  // Authentication icons
  static const IconData login = FontAwesomeIcons.rightToBracket;
  static const IconData logout = FontAwesomeIcons.rightFromBracket;
  static const IconData register = FontAwesomeIcons.userPlus;
  static const IconData forgotPassword = FontAwesomeIcons.key;
  static const IconData email = FontAwesomeIcons.envelope;
  static const IconData password = FontAwesomeIcons.lock;
  static const IconData visibility = FontAwesomeIcons.eye;
  static const IconData visibilityOff = FontAwesomeIcons.eyeSlash;

  // Order management icons
  static const IconData order = FontAwesomeIcons.receipt;
  static const IconData newOrder = FontAwesomeIcons.plus;
  static const IconData editOrder = FontAwesomeIcons.pen;
  static const IconData deleteOrder = FontAwesomeIcons.trash;
  static const IconData viewOrder = FontAwesomeIcons.eye;
  static const IconData approveOrder = FontAwesomeIcons.check;
  static const IconData declineOrder = FontAwesomeIcons.xmark;
  static const IconData pendingOrder = FontAwesomeIcons.clock;
  static const IconData completedOrder = FontAwesomeIcons.checkCircle;
  static const IconData cancelledOrder = FontAwesomeIcons.xmarkCircle;

  // Branch management icons
  static const IconData branch = FontAwesomeIcons.building;
  static const IconData addBranch = FontAwesomeIcons.plus;
  static const IconData editBranch = FontAwesomeIcons.pen;
  static const IconData deleteBranch = FontAwesomeIcons.trash;
  static const IconData viewBranch = FontAwesomeIcons.eye;
  static const IconData branchSettings = FontAwesomeIcons.gear;
  static const IconData branchHours = FontAwesomeIcons.clock;
  static const IconData branchLocation = FontAwesomeIcons.locationDot;
  static const IconData branchPhone = FontAwesomeIcons.phone;
  static const IconData branchEmail = FontAwesomeIcons.envelope;

  // Staff management icons
  static const IconData staffMember = FontAwesomeIcons.user;
  static const IconData addStaff = FontAwesomeIcons.userPlus;
  static const IconData editStaff = FontAwesomeIcons.pen;
  static const IconData deleteStaff = FontAwesomeIcons.trash;
  static const IconData viewStaff = FontAwesomeIcons.eye;
  static const IconData driver = FontAwesomeIcons.car;
  static const IconData manager = FontAwesomeIcons.userTie;
  static const IconData employee = FontAwesomeIcons.user;
  static const IconData staffRole = FontAwesomeIcons.idCard;
  static const IconData staffPermissions = FontAwesomeIcons.shield;

  // Analytics icons
  static const IconData revenue = FontAwesomeIcons.dollarSign;
  static const IconData analyticsOrders = FontAwesomeIcons.list;
  static const IconData customers = FontAwesomeIcons.users;
  static const IconData performance = FontAwesomeIcons.chartBar;
  static const IconData trends = FontAwesomeIcons.chartLine;
  static const IconData statistics = FontAwesomeIcons.chartPie;
  static const IconData reports = FontAwesomeIcons.fileText;
  static const IconData export = FontAwesomeIcons.download;
  static const IconData import = FontAwesomeIcons.upload;
  static const IconData dollar = FontAwesomeIcons.dollarSign;
  static const IconData check = FontAwesomeIcons.check;
  static const IconData trendingUp = FontAwesomeIcons.arrowTrendUp;
  static const IconData personAdd = FontAwesomeIcons.userPlus;

  // Laundry service icons
  static const IconData wash = FontAwesomeIcons.shirt;
  static const IconData dry = FontAwesomeIcons.wind;
  static const IconData iron = FontAwesomeIcons.hammer;
  static const IconData fold = FontAwesomeIcons.hand;
  static const IconData bag = FontAwesomeIcons.bagShopping;
  static const IconData pickup = FontAwesomeIcons.truck;
  static const IconData delivery = FontAwesomeIcons.truckFast;
  static const IconData laundry = FontAwesomeIcons.shirt;
  static const IconData dryClean = FontAwesomeIcons.sprayCan;
  static const IconData press = FontAwesomeIcons.hammer;

  // Status icons
  static const IconData success = FontAwesomeIcons.checkCircle;
  static const IconData error = FontAwesomeIcons.xmarkCircle;
  static const IconData warning = FontAwesomeIcons.triangleExclamation;
  static const IconData info = FontAwesomeIcons.circleInfo;
  static const IconData loading = FontAwesomeIcons.spinner;
  static const IconData pending = FontAwesomeIcons.clock;
  static const IconData active = FontAwesomeIcons.circleCheck;
  static const IconData inactive = FontAwesomeIcons.circleXmark;
  static const IconData online = FontAwesomeIcons.circle;
  static const IconData offline = FontAwesomeIcons.circle;

  // Action icons
  static const IconData add = FontAwesomeIcons.plus;
  static const IconData edit = FontAwesomeIcons.pen;
  static const IconData delete = FontAwesomeIcons.trash;
  static const IconData save = FontAwesomeIcons.floppyDisk;
  static const IconData cancel = FontAwesomeIcons.xmark;
  static const IconData confirm = FontAwesomeIcons.check;
  static const IconData search = FontAwesomeIcons.magnifyingGlass;
  static const IconData filter = FontAwesomeIcons.filter;
  static const IconData sort = FontAwesomeIcons.sort;
  static const IconData refresh = FontAwesomeIcons.arrowsRotate;
  static const IconData reload = FontAwesomeIcons.rotateRight;

  // Navigation action icons
  static const IconData back = FontAwesomeIcons.arrowLeft;
  static const IconData backOutlined = FontAwesomeIcons.arrowLeft;
  static const IconData forward = FontAwesomeIcons.arrowRight;
  static const IconData up = FontAwesomeIcons.arrowUp;
  static const IconData down = FontAwesomeIcons.arrowDown;
  static const IconData close = FontAwesomeIcons.xmark;
  static const IconData menu = FontAwesomeIcons.bars;
  static const IconData more = FontAwesomeIcons.ellipsis;
  static const IconData moreVertical = FontAwesomeIcons.ellipsisVertical;

  // Communication icons
  static const IconData phone = FontAwesomeIcons.phone;
  static const IconData message = FontAwesomeIcons.message;
  static const IconData chat = FontAwesomeIcons.comments;
  static const IconData notification = FontAwesomeIcons.bell;
  static const IconData alert = FontAwesomeIcons.bell;
  static const IconData mail = FontAwesomeIcons.envelope;
  static const IconData call = FontAwesomeIcons.phone;
  static const IconData video = FontAwesomeIcons.video;
  static const IconData voice = FontAwesomeIcons.microphone;

  // File and document icons
  static const IconData file = FontAwesomeIcons.file;
  static const IconData document = FontAwesomeIcons.fileText;
  static const IconData image = FontAwesomeIcons.image;
  static const IconData pdf = FontAwesomeIcons.filePdf;
  static const IconData excel = FontAwesomeIcons.fileExcel;
  static const IconData word = FontAwesomeIcons.fileWord;
  static const IconData folder = FontAwesomeIcons.folder;
  static const IconData download = FontAwesomeIcons.download;
  static const IconData upload = FontAwesomeIcons.upload;
  static const IconData share = FontAwesomeIcons.share;

  // Time and date icons
  static const IconData calendar = FontAwesomeIcons.calendar;
  static const IconData clock = FontAwesomeIcons.clock;
  static const IconData time = FontAwesomeIcons.clock;
  static const IconData date = FontAwesomeIcons.calendar;
  static const IconData schedule = FontAwesomeIcons.calendar;
  static const IconData reminder = FontAwesomeIcons.bell;
  static const IconData deadline = FontAwesomeIcons.flag;
  static const IconData duration = FontAwesomeIcons.hourglass;

  // Location icons
  static const IconData location = FontAwesomeIcons.locationDot;
  static const IconData map = FontAwesomeIcons.map;
  static const IconData pin = FontAwesomeIcons.thumbtack;
  static const IconData marker = FontAwesomeIcons.mapPin;
  static const IconData address = FontAwesomeIcons.locationDot;
  static const IconData gps = FontAwesomeIcons.locationDot;
  static const IconData navigation = FontAwesomeIcons.route;

  // Payment icons
  static const IconData payment = FontAwesomeIcons.creditCard;
  static const IconData card = FontAwesomeIcons.creditCard;
  static const IconData cash = FontAwesomeIcons.moneyBill;
  static const IconData wallet = FontAwesomeIcons.wallet;
  static const IconData money = FontAwesomeIcons.dollarSign;
  static const IconData price = FontAwesomeIcons.tag;
  static const IconData discount = FontAwesomeIcons.percent;
  static const IconData tax = FontAwesomeIcons.calculator;

  // Settings icons
  static const IconData preferences = FontAwesomeIcons.gear;
  static const IconData configuration = FontAwesomeIcons.cog;
  static const IconData profile = FontAwesomeIcons.user;
  static const IconData account = FontAwesomeIcons.user;
  static const IconData security = FontAwesomeIcons.shield;
  static const IconData privacy = FontAwesomeIcons.lock;
  static const IconData help = FontAwesomeIcons.questionCircle;
  static const IconData support = FontAwesomeIcons.headset;
  static const IconData about = FontAwesomeIcons.infoCircle;

  // Utility icons
  static const IconData copy = FontAwesomeIcons.copy;
  static const IconData paste = FontAwesomeIcons.paste;
  static const IconData cut = FontAwesomeIcons.scissors;
  static const IconData undo = FontAwesomeIcons.rotateLeft;
  static const IconData redo = FontAwesomeIcons.rotateRight;
  static const IconData clear = FontAwesomeIcons.eraser;
  static const IconData reset = FontAwesomeIcons.rotateLeft;
  static const IconData refreshData = FontAwesomeIcons.arrowsRotate;
  static const IconData sync = FontAwesomeIcons.arrowsRotate;
}

/// Icon utilities
class IconUtils {
  /// Get icon size from token
  static double getIconSize(String token) {
    switch (token) {
      case 'xs':
        return 12.0;
      case 's':
        return 16.0;
      case 'm':
        return 20.0;
      case 'l':
        return 24.0;
      case 'xl':
        return 32.0;
      case 'xxl':
        return 48.0;
      case 'xxxl':
        return 64.0;
      default:
        return 20.0;
    }
  }

  /// Get icon color from theme
  static Color getIconColor(String variant, ColorScheme colorScheme) {
    switch (variant) {
      case 'primary':
        return colorScheme.primary;
      case 'secondary':
        return colorScheme.secondary;
      case 'tertiary':
        return colorScheme.tertiary;
      case 'error':
        return colorScheme.error;
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'info':
        return AppColors.info;
      case 'onSurface':
        return colorScheme.onSurface;
      case 'onSurfaceVariant':
        return colorScheme.onSurfaceVariant;
      default:
        return colorScheme.onSurface;
    }
  }

  /// Get icon opacity
  static double getIconOpacity(String variant) {
    switch (variant) {
      case 'disabled':
        return 0.38;
      case 'inactive':
        return 0.60;
      case 'active':
        return 1.0;
      case 'hover':
        return 0.87;
      case 'focus':
        return 1.0;
      default:
        return 1.0;
    }
  }
}
