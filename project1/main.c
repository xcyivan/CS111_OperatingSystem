// UCLA CS 111 Lab 1 main program

#include <errno.h>
// #include <error.h>
#include <getopt.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <semaphore.h>      /* sem_open(), sem_destroy(), sem_wait().. */
#include <fcntl.h>          /* O_CREAT, O_EXEC          */
#include <sys/shm.h> 
#include <sys/types.h> 
#include "command.h"
#include "alloc.h"
#include "command-internals.h"


static char const *program_name;
static char const *script_name;


/*--------------helper----------------*/
void print_queue(queue_t queue)
{
  queue_t cur = queue;
  int i = 0;
  while (cur->next != NULL)
  {
    cur = cur->next;
    printf("%d: \n", i);
    print_command(cur->node->command);
    printf("\n");
    i++;
  }
}
/*--------------helper----------------*/

key_t shmkey;                 /*      shared memory key       */
int shmid;                    /*      shared memory id        */
sem_t *sem;                   /*      synch semaphore         *//*shared */
int *p;                       /*      shared variable         *//*shared */
bool visiable;


dependency_graph_t init_dependency_graph()
{
  dependency_graph_t dependency_graph = (dependency_graph_t)checked_malloc(sizeof(struct dependency_graph));
  dependency_graph->no_dependencies = init_queue();
  dependency_graph->dependencies = init_queue();
  return dependency_graph;
}

queue_t init_queue()
{
  queue_t queue = (queue_t)checked_malloc(sizeof(struct queue));
  queue->node = NULL;
  queue->next = NULL;
  return queue;
}

graph_node_t init_graph_node(command_t command)
{
  graph_node_t graph_node = (graph_node_t)checked_malloc(sizeof(struct graph_node));
  graph_node->command = command;
  graph_node->before = init_queue();
  graph_node->pid = -1;
  graph_node->m_readList = init_arr();
  graph_node->m_writeList = init_arr();
  return graph_node;
}

void add_queue(queue_t queue, graph_node_t node)
{
  queue_t new = init_queue();
  new->node = node;
  queue_t cur = queue;
  while (cur->next != NULL)
  {
    cur = cur->next;
  }
  cur->next = new;
}

arr_t init_arr(){
  arr_t newArr = (arr_t) checked_malloc(sizeof(struct arr));
  newArr->itemNum=0;
  return newArr;
}



void processCommand(command_t cmd, graph_node_t gNode){
  if(cmd->type==SIMPLE_COMMAND){
    if(cmd->input!=NULL){
      int itemNum = gNode->m_readList->itemNum;
      gNode->m_readList->item[itemNum] = checked_malloc((size_t)strlen(cmd->input)+1);
      memset(gNode->m_readList->item[itemNum], 0, (size_t)sizeof(strlen(cmd->input)+1));
      strcpy(gNode->m_readList->item[itemNum], cmd->input);
      gNode->m_readList->itemNum++;
    }
    if(cmd->output!=NULL){
      int itemNum = gNode->m_writeList->itemNum;
      gNode->m_writeList->item[itemNum]=checked_malloc(strlen(cmd->output)+1);
      memset(gNode->m_writeList->item[itemNum], 0, sizeof(strlen(cmd->output)+1));
      strcpy(gNode->m_writeList->item[itemNum], cmd->output);
      gNode->m_writeList->itemNum++;
    }
    int i=1;
    for(i=1; cmd->u.word[i]!=0; i++){
      if(cmd->u.word[i][0]!='-'){
        int itemNum = gNode->m_readList->itemNum;
        gNode->m_readList->item[itemNum]=checked_malloc(strlen(cmd->u.word[i])+1);
        memset(gNode->m_readList->item[itemNum], 0, strlen(cmd->u.word[i])+1);
        strcpy(gNode->m_readList->item[itemNum], cmd->u.word[i]);
        gNode->m_readList->itemNum++;
      }
    }
  }

  else if(cmd->type==SUBSHELL_COMMAND){
    if(cmd->input!=NULL){
      int itemNum = gNode->m_readList->itemNum;
      gNode->m_readList->item[itemNum]=checked_malloc(strlen(cmd->input)+1);
      memset(gNode->m_readList->item[itemNum], 0, sizeof(strlen(cmd->input)+1));
      strcpy(gNode->m_readList->item[itemNum], cmd->input);
      gNode->m_readList->itemNum++;
    }
    if(cmd->output!=NULL){
      int itemNum = gNode->m_writeList->itemNum;
      gNode->m_writeList->item[itemNum]=checked_malloc(strlen(cmd->output)+1);
      memset(gNode->m_writeList->item[itemNum], 0, sizeof(strlen(cmd->output)+1));
      strcpy(gNode->m_writeList->item[itemNum], cmd->output);
      gNode->m_writeList->itemNum++;
    }
  }

  else{
    processCommand(cmd->u.command[0],gNode);
    processCommand(cmd->u.command[1],gNode);
  }
}

bool isDependent(graph_node_t n1, graph_node_t n2){
  //n1 is the leading node, n2 is the following node
  int i=0;
  for(i=0; i<n2->m_readList->itemNum; i++){
    //RAW
    int j=0;
    for(j=0; j<n1->m_writeList->itemNum; j++){
      if(!strcmp(n2->m_readList->item[i], n1->m_writeList->item[j]))
        return true;
    }
  }
  for(i=0; i<n2->m_writeList->itemNum; i++){
    //WAR
    int j=0;
    for(j=0; j<n1->m_readList->itemNum; j++){
      if(!strcmp(n2->m_writeList->item[i], n1->m_readList->item[j]))
        return true;
    }
    //WAW
    int k=0;
    for(k=0; k<n1->m_writeList->itemNum; k++){
      if(!strcmp(n2->m_writeList->item[i], n1->m_writeList->item[k]))
        return true;
    }
  }
  return false;
}

void checkDependency(graph_node_t* gnArr, int gnCount){
  int i=0;
  for(i=0; i<gnCount-1; i++){
    if(isDependent(gnArr[i],gnArr[gnCount-1]))
      add_queue(gnArr[gnCount-1]->before, gnArr[i]);
  }
}

dependency_graph_t create_graph(command_stream_t command_stream)
{

  dependency_graph_t graph = init_dependency_graph();
  command_t command_tree;
  graph_node_t gnArr[1024];
  int gnCount=0;
  while ((command_tree = read_command_stream (command_stream))){
    graph_node_t gNode=init_graph_node(command_tree);
    // listNode_t lNode=init_listNode(gNode);
    gnArr[gnCount++]=gNode;
    processCommand(command_tree, gNode);
    checkDependency(gnArr,gnCount);
    if(gNode->before->next==NULL)
      add_queue(graph->no_dependencies,gNode);
    else
      add_queue(graph->dependencies,gNode);
  }
  return graph;
}

void execute_graph(dependency_graph_t graph)
{
  // printf("no_dependencies\n");
  // print_queue(graph->no_dependencies);
  execute_no_dependencies(graph->no_dependencies);
  // printf("dependencies\n");
  // print_queue(graph->dependencies);
  execute_dependencies(graph->dependencies);
}

void execute_no_dependencies(queue_t queue)
{
  // queue_t head = queue;
  queue_t cur = queue;
  while (cur->next != NULL)
  {
    cur = cur->next;
    pid_t pid;

    sem_wait (sem); 
    while ((*p) <= 0);
    (*p)--;
    pid = fork ();
    sem_post(sem);

    if (pid == 0)
    {
      execute_command(cur->node->command, true);
      if (visiable)
        sleep(3);

      sem_wait(sem);
      (*p)++;
      sem_post(sem);

      _exit(0);
    }
    else 
    {
      cur->node->pid = pid;
    }
  }
}

void execute_dependencies(queue_t queue)
{
  queue_t i = queue;
  while (i->next != NULL)
  {

    i = i->next;
    queue_t head_j = i->node->before;
    // printf("before:\n");
    queue_t j = head_j;
    // print_queue(head_j);
    loop:
    while (j->next != NULL)
    {
      j = j->next;
      // if (j->node->pid == -1) break;
      if (j->node->pid == -1) goto loop;
    }
    int status;
    j = head_j;
    while (j->next != NULL)
    {
      j = j->next;
      waitpid(j->node->pid, &status, 0);
    }
    pid_t pid;

    sem_wait (sem); 
    while ((*p) <= 0);
    (*p)--;
    pid = fork ();
    sem_post(sem);

    if(pid == 0)
    {
      execute_command(i->node->command, true);
      if (visiable)
        sleep(3);
      sem_wait(sem);
      (*p)++;
      sem_post(sem);
      _exit(0);
    }
    else
    {
      i->node->pid = pid;
    }
  }
}



static void
usage (void)
{
  error (1, 0, "usage: %s [-pt] SCRIPT-FILE", program_name);
}

static int
get_next_byte (void *stream)
{
  return getc (stream);
}


int
main (int argc, char **argv)
{
  int command_number = 1;
  bool print_tree = false;
  bool time_travel = false;
  program_name = argv[0];
  int a;

  
  /* initialize a shared variable in shared memory */
  shmkey = ftok ("/dev/null", 5);       /* valid directory name and a number */
  // printf ("shmkey for p = %d\n", shmkey);
  shmid = shmget (shmkey, sizeof (int), 0644 | IPC_CREAT);
  if (shmid < 0){                           /* shared memory error check */
      perror ("shmget\n");
      _exit (1);
  }

  p = (int *) shmat (shmid, NULL, 0);   /* attach p to shared memory */

  for (;;)
    switch (getopt (argc, argv, "pvtn:"))
      {
      case 'p': print_tree = true; break;
      case 't': time_travel = true; break;
      case 'n': *p = atoi(optarg); 
                // printf("!!%d\n",(*p));
                break;
      case 'v': visiable = true; break;
      default: usage (); break;
      case -1: goto options_exhausted;
      }
 options_exhausted:;

  sem = sem_open ("pSem", O_CREAT | O_EXCL, 0644, 1); 
  sem_unlink ("pSem");   


  // There must be exactly one file argument.
  if (optind != argc - 1)
    usage ();

  script_name = argv[optind];
  FILE *script_stream = fopen (script_name, "r");
  if (! script_stream)
    error (1, errno, "%s: cannot open", script_name);
  command_stream_t command_stream =
    make_command_stream (get_next_byte, script_stream);

  command_t last_command = NULL;
  command_t command;
  if (time_travel)
  {
    dependency_graph_t graph = create_graph(command_stream);
    execute_graph(graph);
    // _exit(0);
  }
  else
  {
    while ((command = read_command_stream (command_stream)))
    {
      if (print_tree)
    	{
    	  printf ("# %d\n", command_number++);
    	  print_command (command);
    	}
      else
    	{
        // bool flag = false;
    	  last_command = command;
    	  execute_command (command, time_travel);
    	}
    }
  

    return print_tree || !last_command ? 0 : command_status (last_command);
  }
}

