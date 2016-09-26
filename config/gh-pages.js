var ghpages = require('gh-pages');
var path = require('path');

// Documentation deployment
ghpages.publish(
  path.join(__dirname, '..', 'docs'),
  {
    src: [
      'index.html',
      'css/**/*',
      'img/*',
    ],
    message: 'Automatic deployment update',
  },
  function (err) {
    if (err) {
      console.log(err);
    } else {
      console.log('No error in the documentation deployment');

      // Demo deployment
      ghpages.publish(
        path.join(__dirname, '..'),
        {
          src: [
            'README.md',
          ],
          message: 'Automatic deployment update',
          add: true,
        },
        function (err) {
          if (err) {
            console.log(err);
          } else {
            console.log('No error in the demo website deployment');
          }
        }
      );
    }
  }
);
