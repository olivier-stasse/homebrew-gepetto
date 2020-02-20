class PinocchioAT2 < Formula
  desc "An efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  head "https://github.com/stack-of-tasks/pinocchio.git", :branch => "devel"

  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.3.0/pinocchio-2.3.0.tar.gz"
  sha256 "9bab5178096497e900a76bc4e88ad65bfb143256b719a35f3fc16a00a6a4dc49"

  bottle do
    root_url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.3.0"
    sha256 "2b50ddc989f67ac450d8770c7549e9632b3f4327f07d46ad1177923344852278" => :mojave
  end

  option "without-python", "Build without Python support"
  option "without-fcl", "Build without FCL support"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "urdfdom" => :recommended
  depends_on "boost-python" => :recommended if build.with? "python"
  depends_on "eigenpy" => :recommended if build.with? "python"
  depends_on "python@2" => :recommended if build.with? "python"
  depends_on "hpp-fcl" => :recommended if build.with? "fcl"

  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end

    pyver = Language::Python.major_minor_version "python2"
    py_prefix = Formula["python@2"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    
    mkdir "build" do
      args = *std_cmake_args
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << "-DPYTHON_EXECUTABLE=#{py_prefix}/bin/python2"
      args << "-DBUILD_UNIT_TESTS=OFF"
      args << "-DBUILD_WITH_COLLISION_SUPPORT=ON"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end