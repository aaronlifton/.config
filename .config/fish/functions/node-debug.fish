function node-debug --description "node --inspect-brk"
    node --inspect-brk node_modules/.bin/jest --projects src/jest.config.rtl.js --no-coverage --colors $argv[1]
end
