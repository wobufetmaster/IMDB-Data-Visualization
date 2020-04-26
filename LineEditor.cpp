#include <iostream>
#include <fstream>
#include <string>
#include "editorFunc.h"

using namespace std;

int main(){
	
	string readmyFile;
	string writemyFile;
	int getnum;
	
	cout<<"1.cert 2.genres 3.keywords 4.movies 5.ratings 6.release-dates 7.running-times\n";
	cout<<"File to read:: ";
	cin>>getnum;
	
	
	while(1){
			
		cout<<"\nFile to write to:: ";
		cin>>writemyFile;
		cout<<endl;
		if (writemyFile == "certificates.txt" 
		|| writemyFile == "genres.txt"  
		|| writemyFile == "keywords.txt" 
		|| writemyFile == "movies.txt" 
		|| writemyFile == "ratings.txt" 
		|| writemyFile == "release-dates.txt" 
		|| writemyFile == "running-times.txt" ){
			cout<<"\n:::Cannot write to this file. Select another file name:::\n";
		}else{
			break;
		}
		
	}
	
	switch (getnum){
		case 1: readmyFile = "certificates.txt";
			cout<<"\nGetting certificates.txt\n";
			editCertificates(readmyFile,writemyFile);
			break;	
		case 2: readmyFile = "genres.txt";
			cout<<"\nGetting genres.txt\n";
			editGenres(readmyFile,writemyFile);
			break;
		case 3: readmyFile = "keywords.txt";
			cout<<"\nGetting keywords.txt\n";
			editKeywords(readmyFile,writemyFile);
			break;
		case 4: readmyFile = "movies.txt";
			cout<<"\nGetting movies.txt\n";
			editMovies(readmyFile,writemyFile);
			break;
		case 5: readmyFile = "ratings.txt";
			cout<<"\nGetting ratings.txt\n";
			break;
		case 6: readmyFile = "release-dates.txt";
			cout<<"\nGetting release-dates.txt\n";
			editRelease(readmyFile,writemyFile);
			break;
		case 7: readmyFile = "running-times.txt";
			cout<<"\nGetting running-times.txt\n";
			break;
	}
	
	
	
	
	
	
	
	
	 
}
