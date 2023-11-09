// Inspired by https://pablomusumeci.com/productivity/open-links-in-different-chrome-profiles/
// Define browsers
const personal = {
  name: "Google Chrome",
  profile: "Profile 1",
};

const work = {
  name: "Google Chrome",
  profile: "Default",
};

const slackApp = "/Applications/Slack.app";

module.exports = {
  defaultBrowser: "Google Chrome",
  options: {
    hideIcon: false,
    checkForUpdate: true,
  },
  handlers: [
    {
      match: [
        "zoom.us/*",
        finicky.matchDomains(/.*\zoom.us/),
        /zoom.us\/j\//,
      ],
      browser: "us.zoom.xos"
    },
    {
      match: finicky.matchDomains("https://open.spotify.com"),
      browser: "Spotify"
    },
    // Slack deeplinks
    {
      match: ({
        url
      }) => url.protocol === "slack",
      browser: slackApp,
    },
    // Open Slack links in the app
    {
      match: /slack.com/,
      browser: slackApp,
    },
    // Social media
    {
      match: /facebook|twitter|instagram/,
      browser: personal,
    },
    {
      match: "*.linkedin.com/*",
      browser: personal
    },
    // Work Stuff
    {
      match: "https://dev.azure.com/RMI_PACTA/*",
      browser: work     
    },
    {
      match: "rmi.mavenlink.com/*",
      browser: work     
    },
    {
      match: "rockmtnins.sharepoint.com/*",
      browser: work
    },
    {
      match: "rockmtnins-my.sharepoint.com/*",
      browser: work     
    },
  ]
};
