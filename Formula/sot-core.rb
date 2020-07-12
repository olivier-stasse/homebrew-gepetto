class SotCore < Formula
  desc "Stack-Of-Tasks sot-core"
  homepage "https://github.com/stack-of-tasks/sot-core"
  url "https://github.com/stack-of-tasks/sot-core/releases/download/v4.9.1/sot-core-4.9.1.tar.gz"
  sha256 "1ecd97cb1f1d4ae5b862903147beb7bc575fc5444097c70f86061aecb71e8dc4c"
  head "https://github.com/stack-of-tasks/sot-core.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/sot-core/releases/download/v4.9.1"
    sha256 "4c4ddf4a62fcaac66d5c3d49c2cd81b231ee59299ed21697cbd5ed9024057ac6" => :catalina
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"
  depends_on "python@3.8" => :build
  depends_on "dynamic-graph-python" => :build
  depends_on "boost-python3" => :recommended
  depends_on "pinocchio" => :build
  
  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end
    
    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py_prefix = Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    mkdir "build" do
      args = *std_cmake_args
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python#{pyver}"
      args << "-DBUILD_UNIT_TESTS=OFF"
      args << "-DCMAKE_BUILD_TYPE=Release"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
