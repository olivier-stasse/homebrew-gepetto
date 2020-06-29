class DynamicGraph < Formula
  desc "Dynamic Graph"
  homepage "https://github.com/stack-of-tasks/dynamic-graph"
  url "https://github.com/stack-of-tasks/dynamic-graph/releases/download/v4.2.1/dynamic-graph-v3-4.2.1.tar.gz"
  Sha256 "2c0f0cc3ce88112013f27be6e381d5abea821573"
  head "https://github.com/stack-of-tasks/dynamic-graph.git", :branch => "devel"

#  bottle do
#    root_url "https://github.com/stack-of-tasks/dynamic-graph/releases/download/v4.2.1"
#    sha256 "9e7db5a4c8d133ad24cdda67ac5e19d94932fcdd9795cd308097259f04bffc40" => :mojave
#  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "eigen"

  def install
    if build.head?
      system "git submodule update --init"
      system "git pull --unshallow --tags" 
    end

    mkdir "build" do
      args = *std_cmake_args
      args << "-DBUILD_UNIT_TESTS=OFF"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "false"
  end
end
