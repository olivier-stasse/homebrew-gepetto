class Pinocchio < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio"

  stable do
    url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.1.0/pinocchio-2.1.0.tar.gz"
    sha256 "72c9690e3da92a06d96d7a04dad4e081318c0c5070ad1316d82ab5c204297139"
    
    patch :DATA
  end

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.1.0/pinocchio-2.1.0.mojave.bottle.tar.gz"
    sha256 "8d334273e9cc6c2d0861105bbdfa1a90dd59f78b735bcb8f20ba9d5432c20afd" => :mojave
  end

  #head do
  #  url "https://github.com/jcarpent/pinocchio.git", :branch => "master"
  #end

  #devel do
  #  url "https://github.com/jcarpent/pinocchio.git", :branch => "devel"
  #end

  option "without-python", "Build without Python support"
  option "without-fcl", "Build without FCL support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "boost-python" => :recommended if build.with? "python"
  depends_on "urdfdom" => :recommended
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "python@2" => :recommended if build.with? "python"
  depends_on "numpy" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "fcl"

  def install
    if build.devel?
      system "git submodule update --init"
    end

    pyver = Language::Python.major_minor_version "python2"
    py_prefix = Formula["python2"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}m"
      args << "-DPYTHON_LIBRARY=#{py_prefix}/lib"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python2"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
__END__
