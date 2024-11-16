class Post {
  String title;
  int numUpVotes;
  int numDownVotes;

  Post(this.title, this.numUpVotes, this.numDownVotes);

  static List<Post> generateData() {
    return [
      Post('Go Module Mirror and Checksum Database Launched (golang.org)', 2, 0),
      Post('Dqlite - High-Availability SQLite (dqlite.io)', 2, 2),
      Post('A deep dive into iOS Exploit chains found in the wild (googleprojectzero.blogspot.com)', 3, 0),
      Post('NPM Bans Terminal Ads (zdnet.com)', 0, 1),
      Post('The Portuguese Bank Note Crisis of 1925 (wikipedia.org)', 2, 0),
    ];
  }
}