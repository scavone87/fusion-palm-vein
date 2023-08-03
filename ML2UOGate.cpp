#include "mex.h"
#include <stdlib.h>
#include <math.h>
#include <windows.h>

/*
This would be a MEX file for MATLAB.
*/

int WaitSignal(int p1, int p2)
{
    HANDLE hEvent = NULL;
    
    if(p1 == 0)
        hEvent = ::CreateEvent(NULL, TRUE, FALSE, "UO2ML_INIT_EVENT");
    else
        hEvent = ::OpenEvent(SYNCHRONIZE | EVENT_MODIFY_STATE, 0, "UO2ML_SAVE_EVENT");
    
    if(!hEvent)
        return -1;
    
    DWORD dResult = ::WaitForSingleObject(hEvent, (DWORD)p2);
    
    if(dResult == WAIT_OBJECT_0)
    {
        if(p1 == 1)
            ::ResetEvent(hEvent);
        
        ::CloseHandle(hEvent);
        return 0;
    }
    
    if(dResult == WAIT_TIMEOUT)
    {
        ::CloseHandle(hEvent);
        return 1;
    }

	return -1;
}

int SendMessage(int Param1, int Param2)
{
    HWND UoWin = ::FindWindow(NULL, "ULA-OP Modula - RealTime Software");
    if(!UoWin)
        return -1;
    
    const UINT MsgID = ::RegisterWindowMessage("ML2UOCMD");
    if(!MsgID)
        return -1;
    
    BOOL bRet = ::PostMessage(UoWin, MsgID, (WPARAM)Param1, (LPARAM)Param2);
    if(!bRet)
        return -1;
    
    return 0;
}

int Execute(int Param1, char *str)
{
    LPCTSTR v[4];
    char *s = str;
    
    for(int k=0;k<4;k++)
    {
        if(*s == '?')
            v[k] = NULL;
        else
            v[k] = s;
        
        while(*s != '?')
            s++;
        
        *s++ = 0;
    }
    
    unsigned int Result = (unsigned int)ShellExecute(NULL, v[0], v[1], v[2], v[3], Param1);
    if(Result <= 32)
        return -1;
    
    return 0;
}


void mexFunction(int nlhs,mxArray *plhs[],int nrhs, const mxArray *prhs[])
{   
    // check for arguments
    if(nrhs < 3) { mexErrMsgTxt("3 inputs required."); }
    if(nlhs != 1) { mexErrMsgTxt("1 output required."); }
    
    // get input parameters
    int Task = (int)(double)mxGetScalar(prhs[0]);
    int Param1 = (int)(double)mxGetScalar(prhs[1]);
    int Param2 = (int)(double)mxGetScalar(prhs[2]);
    
    int Out = 0;
    switch(Task)
    {
        case(0):
            Out = WaitSignal(Param1, Param2);
            break;
            
        case(1):
            Out = SendMessage(Param1, Param2);
            break;
        
        case(2):
        {   
            if(nrhs != 4) { mexErrMsgTxt("4 inputs required."); }
            mwSize buflen = mxGetN(prhs[3]) + 1;
            char *strbuf = (char*)mxCalloc(buflen, sizeof(char));
            mxGetString(prhs[3], strbuf, buflen);
            Out = Execute(Param1, strbuf);
            mxFree(strbuf);
        }
            break;
    }
    
    // create the output vector, get pointer and write
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    double *Output = mxGetPr(plhs[0]);
    *Output = (double)Out;
}
