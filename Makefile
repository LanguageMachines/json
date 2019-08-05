# Tell versions [3.59,3.63) of GNU make to not export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
=======
##########################################################################
# CMake
##########################################################################

# grep "^option" CMakeLists.txt test/CMakeLists.txt | sed 's/(/ /' | awk '{print $2}' | xargs

# check if all flags of our CMake files work
check_cmake_flags_do:
	$(CMAKE_BINARY) --version
	for flag in '' JSON_BuildTests JSON_Install JSON_MultipleHeaders JSON_Sanitizer JSON_Valgrind JSON_NoExceptions JSON_Coverage; do \
		rm -fr cmake_build; \
		mkdir cmake_build; \
		echo "$(CMAKE_BINARY) .. -D$$flag=On" ; \
		cd cmake_build ; \
		CXX=g++-8 $(CMAKE_BINARY) .. -D$$flag=On -DCMAKE_CXX_COMPILE_FEATURES="cxx_std_11;cxx_range_for" -DCMAKE_CXX_FLAGS="-std=gnu++11" ; \
		test -f Makefile || exit 1 ; \
		cd .. ; \
	done;

# call target `check_cmake_flags_do` twice: once for minimal required CMake version 3.1.0 and once for the installed version
check_cmake_flags:
	wget https://github.com/Kitware/CMake/releases/download/v3.1.0/cmake-3.1.0-Darwin64.tar.gz
	tar xfz cmake-3.1.0-Darwin64.tar.gz
	CMAKE_BINARY=$(abspath cmake-3.1.0-Darwin64/CMake.app/Contents/bin/cmake) $(MAKE) check_cmake_flags_do
	CMAKE_BINARY=$(shell which cmake) $(MAKE) check_cmake_flags_do


##########################################################################
# ChangeLog
##########################################################################

# Create a ChangeLog based on the git log using the GitHub Changelog Generator
# (<https://github.com/github-changelog-generator/github-changelog-generator>).

# variable to control the diffs between the last released version and the current repository state
NEXT_VERSION ?= "unreleased"

ChangeLog.md:
	github_changelog_generator -o ChangeLog.md --simple-list --release-url https://github.com/nlohmann/json/releases/tag/%s --future-release $(NEXT_VERSION)
	$(SED) -i 's|https://github.com/nlohmann/json/releases/tag/HEAD|https://github.com/nlohmann/json/tree/HEAD|' ChangeLog.md
	$(SED) -i '2i All notable changes to this project will be documented in this file. This project adheres to [Semantic Versioning](http://semver.org/).' ChangeLog.md


##########################################################################
# Release files
##########################################################################

# Create the files for a release and add signatures and hashes. We use `-X` to make the resulting ZIP file
# reproducible, see <https://content.pivotal.io/blog/barriers-to-deterministic-reproducible-zip-files>.

release:
	rm -fr release_files
	mkdir release_files
	zip -9 --recurse-paths -X include.zip $(SRCS)
	gpg --armor --detach-sig include.zip
	mv include.zip include.zip.asc release_files
	gpg --armor --detach-sig $(AMALGAMATED_FILE)
	cp $(AMALGAMATED_FILE) release_files
	mv $(AMALGAMATED_FILE).asc release_files
	cd release_files ; shasum -a 256 json.hpp > hashes.txt
	cd release_files ; shasum -a 256 include.zip >> hashes.txt


##########################################################################
# Maintenance
##########################################################################

# clean up
clean:
	rm -fr json_unit json_benchmarks fuzz fuzz-testing *.dSYM test/*.dSYM oclint_report.html
	rm -fr benchmarks/files/numbers/*.json
	rm -fr cmake-3.1.0-Darwin64.tar.gz cmake-3.1.0-Darwin64
	rm -fr build_coverage build_benchmarks fuzz-testing clang_analyze_build pvs_studio_build infer_build clang_sanitize_build cmake_build
	$(MAKE) clean -Cdoc
	$(MAKE) clean -Ctest

##########################################################################
# Thirdparty code
##########################################################################

update_hedley:
	rm -f include/nlohmann/thirdparty/hedley/hedley.hpp include/nlohmann/thirdparty/hedley/hedley_undef.hpp
	curl https://raw.githubusercontent.com/nemequ/hedley/master/hedley.h -o include/nlohmann/thirdparty/hedley/hedley.hpp
	gsed -i 's/HEDLEY_/JSON_HEDLEY_/g' include/nlohmann/thirdparty/hedley/hedley.hpp
	grep "[[:blank:]]*#[[:blank:]]*undef" include/nlohmann/thirdparty/hedley/hedley.hpp | grep -v "__" | sort | uniq | gsed 's/ //g' | gsed 's/undef/undef /g' > include/nlohmann/thirdparty/hedley/hedley_undef.hpp
	$(MAKE) amalgamate
>>>>>>> a015b78e81c859b88840cb0cd4001ce1fe5e7865
