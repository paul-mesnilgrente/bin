#include <iostream>
#include <algorithm>
#include <opencv2/opencv.hpp>

void usage()
{
    std::cout << "Usage:";
    std::cout << "    crop image image_cropped";
}

struct userdata
{
	cv::Point_<int> p1 = cv::Point_<int>(-1, -1);
	cv::Point_<int> p2 = cv::Point_<int>(-1, -1);
	bool contouring = false;
	cv::Mat image;
	std::string path2file;
};

std::ostream& operator<<(std::ostream & out, const userdata & d)
{
	return out << "(" << d.p1.x << ", " << d.p1.y << ") "
			   << "(" << d.p2.x << ", " << d.p2.y << ") "	
			   << d.contouring << " ";
}

cv::Point_<int> compute(cv::Point_<int> p1, int x, int y)
{
    int m = std::max(abs(p1.x - x), abs(p1.y - y));
    return cv::Point_<int>(p1.x + m, p1.y + m);
}

void callback(int event, int x, int y, int flags, void* ud)
{
	userdata * data = (userdata*) ud;
	// left button clicked
	if  (event == cv::EVENT_LBUTTONDOWN) {
		data->contouring = !data->contouring;
		if (data->contouring)
			data->p1 = cv::Point_<int>(x, y);
		else
			data->p2 = compute(data->p1, x, y);
	}
	// right button clicked
	else if  (event == cv::EVENT_RBUTTONDOWN) {
		if (data->p1 == cv::Point_<int>(-1, -1)) return;
		if (data->p2 == cv::Point_<int>(-1, -1)) {
			data->p2 = cv::Point_<int>(x, y);
		}
		int xr = std::min(data->p1.x, data->p2.x);
		int yr = std::min(data->p1.y, data->p2.y);
		cv::Mat cropped = data->image(cv::Rect(
								 xr, yr,
								 abs(data->p1.x - data->p2.x),
								 abs(data->p1.y - data->p2.y)));
		cv::resize(cropped, cropped, cv::Size(200, 200));
		cv::imwrite(data->path2file, cropped);
		exit(0);
	// mouse moved in the window
	} else if (event == cv::EVENT_MOUSEMOVE) {
		if (data->contouring) {
			cv::Mat img2show;
			data->image.copyTo(img2show);
			cv::rectangle(img2show,
						  data->p1,
                          compute(data->p1, x, y),
						  cv::Scalar(0, 255, 0));
			cv::imshow("Image", img2show);
		}
	}
}

int main(int argc, char** argv)
{
    if (argc < 3) {
        usage(); return 1;
    }
	userdata data;
	data.path2file = argv[2];
    data.image = cv::imread(argv[1]);
    if (data.image.data == NULL) {
        std::cout << "ERROR: while reading" << 
                     argv[1] << std::endl;
        return 2;
    }
	cv::namedWindow("Image", cv::WINDOW_AUTOSIZE);
	cv::setMouseCallback("Image", callback, &data);
    cv::imshow("Image", data.image);

    cv::waitKey(0);
    return 0;
}
