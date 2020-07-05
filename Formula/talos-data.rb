class TalosData < Formula
  desc "Stack-Of-Tasks talos-data"
  homepage "https://github.com/stack-of-tasks/talos_data"
  url "https://github.com/stack-of-tasks/talos-data/releases/download/v1.2.2/talos_data-1.2.2.tar.gz"
  sha256 "1ecd97cb1f1d4ae5b862903147beb7bc575fc5444097c70f86061aecb71e8dc4c"
  head "https://github.com/stack-of-tasks/talos_data.git", :branch => "devel"

  bottle do
    root_url "https://github.com/stack-of-tasks/talos_data/releases/download/v1.2.2"
    sha256 "4c4ddf4a62fcaac66d5c3d49c2cd81b231ee59299ed21697cbd5ed9024057ac6" => :catalina
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  
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
