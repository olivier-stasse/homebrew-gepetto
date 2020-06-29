class DynamicGraph < Formula
  desc "Stack-Of-Tasks Dynamic Graph"
  homepage "https://github.com/stack-of-tasks/dynamic-graph"
  url "https://github.com/stack-of-tasks/dynamic-graph/releases/download/v4.2.1/dynamic-graph-v3-4.2.1.tar.gz"
  sha256 "807565a836963d1f05ca8acf16366760b3c5c9a38bb60d8e75c422419747ea89"
  head "https://github.com/stack-of-tasks/dynamic-graph.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/dynamic-graph/releases/download/v4.2.1"
    sha256 "4c4ddf4a62fcaac66d5c3d49c2cd81b231ee59299ed21697cbd5ed9024057ac6" => :catalina
  end

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
