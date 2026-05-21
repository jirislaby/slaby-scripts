#include <sl/helpers/Color.h>
#include <sl/helpers/Exception.h>

using Clr = SlHelpers::Color;
using RunEx = SlHelpers::RuntimeException;
//using SlHelpers::raise;

namespace {

void handledMain(int /*argc*/, char **/*argv*/)
{

}

}

int main(int argc, char **argv)
{
	try {
		handledMain(argc, argv);
	} catch (const std::exception &e) {
		Clr(std::cerr, Clr::RED) << e.what();
		return EXIT_FAILURE;
	}

	return 0;
}

