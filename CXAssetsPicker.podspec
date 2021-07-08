#
# Be sure to run `pod lib lint CXAssetsPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do | s |
    s.name             = 'CXAssetsPicker'
    s.version          = '1.0'
    s.summary          = '相册图片选择器'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = '相册图片选择器'

    s.homepage         = 'https://github.com/ishaolin/CXAssetsPicker'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'wshaolin' => 'ishaolin@163.com' }
    s.source           = { :git => 'https://github.com/ishaolin/CXAssetsPicker.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    
    s.resource_bundles = { 'CXAssetsPicker' => ['CXAssetsPicker/Assets/*.png'] }
    
    s.public_header_files = 'CXAssetsPicker/Classes/**/*.h'
    s.source_files = 'CXAssetsPicker/Classes/**/*'
    
    s.dependency 'JPImageresizerView', '1.9.3'
    s.dependency 'CXFoundation'
    s.dependency 'CXUIKit'
end
