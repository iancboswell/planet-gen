requirejs.config({
    //Automatically load modules from lib
    baseUrl: 'lib',
    paths: {
        src: '../src',
        res: '../res',
        three: 'three.min',
        jquery: 'jquery-1.9.1',
        jqueryui: 'jquery-ui-1.10.3.custom'
    },
    shim: {
        'three': {
            exports: 'THREE'
        },
        'jquery': {
            exports: '$'
        }
    }
});

// Start main app logic
requirejs(['cs!src/main'], function (main) {
    main.run();
});