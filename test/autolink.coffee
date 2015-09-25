# autolink test
assert = require 'assert'
autolink = require '../'

describe 'html escape',->
    it 'escape &',->
        assert.equal autolink("foo&bar"),"foo&amp;bar"
    it 'escape < >',->
        assert.equal autolink("foo</a>bar<a>"), "foo&lt;/a&gt;bar&lt;a&gt;"
    it 'escape " \'',->
        assert.equal autolink('foo">aaa</a>bbb<a href=\''), "foo&quot;&gt;aaa&lt;/a&gt;bbb&lt;a href=&#39;"

describe 'url linking',->
    describe 'scheme & host',->
        it 'hostname',->
            assert.equal autolink("foo http://example.net bar"), "foo <a href='http://example.net'>http://example.net</a> bar"
        it 'peroid-terminated fqdn',->
            assert.equal autolink("foohttps://example.com. 3"), "foo<a href='https://example.com.'>https://example.com.</a> 3"
        it 'do not link single-parted name',->
            assert.equal autolink("foo http://invalid あいう"), "foo http://invalid あいう"
        it 'but localhost is valid',->
            assert.equal autolink("foo http://localhost あいう"), "foo <a href='http://localhost'>http://localhost</a> あいう"
        it 'ipv4addr',->
            assert.equal autolink("http://192.168.0.1"), "<a href='http://192.168.0.1'>http://192.168.0.1</a>"
        it 'ipv6addr',->
            assert.equal autolink("http://[2404:6800:4004:813::2003]"), "<a href='http://[2404:6800:4004:813::2003]'>http://[2404:6800:4004:813::2003]</a>"
    describe 'paths',->
        it 'basic',->
            assert.equal autolink("foo http://example.net/bar"), "foo <a href='http://example.net/bar'>http://example.net/bar</a>"
        it 'multibyte',->
            assert.equal autolink("foo http://例え.テスト/吉野家　←全角スペース"), "foo <a href='http://例え.テスト/吉野家'>http://例え.テスト/吉野家</a>　←全角スペース"
        it 'special chars',->
            assert.equal autolink("あ http://google.co.jp/?abc={foo}#あいう"), "あ <a href='http://google.co.jp/?abc={foo}#あいう'>http://google.co.jp/?abc={foo}#あいう</a>"
    describe 'ports',->
        it 'port',->
            assert.equal autolink("foo http://example.net:8080/bar 3"), "foo <a href='http://example.net:8080/bar'>http://example.net:8080/bar</a> 3"

describe 'multiples',->
    it 'urls',->
        assert.equal autolink("foo http://example.net http://subdomain.of.example.org/foo !!!"), "foo <a href='http://example.net'>http://example.net</a> <a href='http://subdomain.of.example.org/foo'>http://subdomain.of.example.org/foo</a> !!!"
