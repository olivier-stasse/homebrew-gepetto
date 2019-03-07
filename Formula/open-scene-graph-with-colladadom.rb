class OpenSceneGraphWithColladadom < Formula
  desc "3D graphics toolkit with collada support"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.6.3.tar.gz"
  sha256 "51bbc79aa73ca602cd1518e4e25bd71d41a10abd296e18093a8acfebd3c62696"
  head "https://github.com/openscenegraph/OpenSceneGraph.git"

  conflicts_with "open-scene-graph", :because => "open-scene-graph also provides the same binaries"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-gepetto"
    rebuild 1
    sha256 "4b2ed2063cc163a566dbe77ef74c5c8a7ae8e36e00b946f23b0b02ede944980e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gtkglext"
  depends_on "jpeg"
  depends_on "sdl"
  depends_on "collada-dom"

  # patch necessary to ensure support for gtkglext-quartz
  # filed as an issue to the developers https://github.com/openscenegraph/osg/issues/34
  patch :DATA

  def install
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    args = std_cmake_args + %w[
      -DBUILD_DOCUMENTATION=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_cairo=ON
      -DCMAKE_CXX_FLAGS=-Wno-error=narrowing
      -DCMAKE_OSX_ARCHITECTURES=x86_64
      -DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio
      -DOSG_WINDOWING_SYSTEM=Cocoa
    ]

    args << "-DCMAKE_DISABLE_FIND_PACKAGE_COLLADA=OFF"
    args << "-DCOLLADA_INCLUDE_DIR=#{Formula["collada-dom"].opt_include}/collada-dom2.5"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc_openscenegraph"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"]
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <osg/Version>
      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-losg", "-o", "test"
    assert_equal `./test`.chomp, version.to_s
  end
end
__END__
diff --git a/CMakeModules/FindGtkGl.cmake b/CMakeModules/FindGtkGl.cmake
index 321cede..6497589 100644
--- a/CMakeModules/FindGtkGl.cmake
+++ b/CMakeModules/FindGtkGl.cmake
@@ -10,7 +10,7 @@ IF(PKG_CONFIG_FOUND)
     IF(WIN32)
         PKG_CHECK_MODULES(GTKGL gtkglext-win32-1.0)
     ELSE()
-        PKG_CHECK_MODULES(GTKGL gtkglext-x11-1.0)
+        PKG_CHECK_MODULES(GTKGL gtkglext-quartz-1.0)
     ENDIF()

 ENDIF()
