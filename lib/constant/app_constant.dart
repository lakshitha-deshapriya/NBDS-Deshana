class AppConstant{
  static double navbarHeight;
  static String sandbox = 'nbds-sandbox';
  static String prod = 'nbds-prod';
  static String env = sandbox;
  static String downloadPortName = 'downloader_send_port';

  static const int DOWNLOADABLE_STATE = 0;
  static const int DOWNLOADING_STATE = 1;
  static const int DOWNLOADED_STATE = 2;
  static const int DOWNLOAD_FAIL = 3;
}