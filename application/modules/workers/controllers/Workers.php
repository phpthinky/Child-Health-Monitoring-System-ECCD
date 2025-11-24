<?php
defined('BASEPATH') or exit('No direct script access allowed');
use PhpOffice\PhpSpreadsheet\Spreadsheet;
/**
  * 
  */
 class Workers extends MY_Controller
 {
  private $workersId;
  function __construct()
  {
    // code...
    parent::__construct();
   
    if (!$this->aauth->is_loggedin()) {
      // code...
      redirect('login?url='.current_url());
    }
    $this->workersId = $this->session->userdata('workersId');
    /*
    if (!$this->aauth->is_admin()) {
      // code...
      redirect('permission/deny');
    }
    */
    $this->load->model('centers/centers_model');
    $this->load->model('settings/settings_model');
    $this->load->model('workers_model');
  }
  public function index()
  {
    if ($this->input->post()) {
      // code...
      $form = $this->input->post('form');
      switch ($form) {
        case 'add':
        $this->add();
        break;
        case 'remove':
          // code...
        if($result = $this->workers_model->remove($this->input->post('id'))){
          echo json_encode(array('status'=>true,'msg'=>'Successfully remove.'));
        }else{
          echo json_encode(array('status'=>true,'msg'=>'Nothing to remove.'));

        }
        
          break;
        case 'info':
          $result = $this->workers_model->getWorker($this->input->post('id'));
        echo json_encode($result);
          break;
        case 'edit':
          $this->edit();
        break;

        default:
          // code...
        echo json_encode(noinput());
          break;
      }
      exit();
    }
    $data = new stdClass();

    $data->centers = $this->centers_model->getCenters();
    $data->workers = $this->workers_model->list_active_Workers();
    $data->all_workers = $this->workers_model->list_all_Workers();
    $data->schoolyears = $this->settings_model->listschoolyears();
    $data->content = 'workers/index';

    $this->template->dashboard($data);

  }

  public function add($value='')
  {
    // code...

    if ($this->input->post()) {
      $data2 = new stdClass();


      $data2->fName = $this->input->post('fName');
      $data2->mName = $this->input->post('mName');
      $data2->lName = $this->input->post('lName');
      $data2->ext = $this->input->post('ext');
      $data2->address = $this->input->post('address');
      $data2->centerId = $this->input->post('centerId');
      $data2->birthDate = $this->input->post('birthday');
      $data2->jobStatus = $this->input->post('jobStatus');
      $data2->dateHired = $this->input->post('dateHired');
      $data2->gender = $this->input->post('gender');
      if ($this->aauth->user_exist_by_email($this->input->post('email'))) {
        // code...
        echo json_encode(array('status'=>false,'msg'=>'Email already used.'));
        exit();
      }
      // Generate secure random password
      $randomPassword = bin2hex(random_bytes(6)); // 12 character random password
      $data2->userId = $this->aauth->create_user($this->input->post('email'), $randomPassword);

        if($result = $this->workers_model->save($data2)){
          echo json_encode(array('status'=>true,'msg'=>'Worker added successfully. Temporary password: '.$randomPassword.' (Please save this - it will only be shown once)'));
        }else{
          echo json_encode(array('status'=>false,'msg'=>'Error adding worker.'));

        }
          
        
      }

  }

  public function edit($value='')
  {
    // code...
    if ($this->input->post()) {
      // code...
      $data = $this->workers_model->getWorker($this->input->post('workersId'));
      $data2 = new stdClass();

      $data2->workersId = $this->input->post('workersId');
      $data2->centerId = $this->input->post('centerId');

      $data2->fName = $this->input->post('fName');
      $data2->mName = $this->input->post('mName');
      $data2->lName = $this->input->post('lName');
      $data2->ext = $this->input->post('ext');
      $data2->address = $this->input->post('address');
      $data2->birthDate = $this->input->post('birthday');
      $data2->jobStatus = $this->input->post('jobStatus');
      $data2->dateHired = $this->input->post('dateHired');
      $data2->gender = $this->input->post('gender');

     //  $data2->userId = $this->aauth->create_user($this->input->post('email'),'123456');
      //$this->aauth->update_user($data2->userId);
        if($result = $this->workers_model->save($data2)){

          if ($this->input->post('email') !== $data->email) {
            // code...
            $this->aauth->update_user($data->userId,$this->input->post('email'));
          }
          echo json_encode(update());
        }else{
          echo json_encode(update(1));

        }
          
    }    


  }
  public function removeuser($value='')
  {
    // code...
    //$this->aauth->delete_user(5);
    //$this->aauth->delete_user(6);
  }
  public function listmyschoolyear($id=0)
  {
    // code...
    if ($id == 0) {
      // code...
      $id = $this->workersId;
    }
    $data = array('worker_id'=>$id);
    if($myschoolyear = $this->workers_model->listmyschoolyear($data)){
      $data = array();
      foreach ($myschoolyear as $key => $val){
            $data[] = array(

                        $val->year_id,
                        $val->center_name,
                        tomdy($val->class_start),
                        tomdy ($val->class_end),
                        $val->total_students,
                        $val->class_status,
                        '<a href="'.site_url('students?year='.$val->year_id.'&worker='.$val->worker_id).'" title="View students" class="btn btn-default btn-sm"><i class="fa fa-list"></i></a> <button title="Delete from my list" class="btn btn-default btn-sm btn-trash-schoolyear" data-id="'.$val->year_id.'"><i class="fa fa-trash"></i></button>'
                    );
      }
      echo json_encode(array('data'=>$data));
      

    }else{
      echo json_encode(array('data'=>false));
    }

  }
  public function profile($workersId=false)
  {
    // code...
    if ($this->input->post()) {
      // code...
      $form = $this->input->post('form');
        switch ($form) {
          case "add_schoolyear":
            $postdata = new stdClass();
            $postdata->YearStart = $this->input->post('startdate');
            $postdata->YearEnd = $this->input->post('enddate');
            //$postdata->Status = $this->input->post('status');

            $year1 = $postdata->YearStart;
            $year2 = $postdata->YearEnd;
            $date= getAge($year1,$year2);
            //$count = $date->y;
            //echo  json_encode (array  ('status'=>false,'msg'=>$year_count->y ));

            if ($year2 < $year1) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid date!'));
              exit();
            }

            if ($date->y > 0) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be more than a year.'));
              exit();
            }

            
            if (($date->y * 12) + $date->m  <= 8 ) {
                // code...

              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be less than 8 months.'));
              exit();

            
            }

            exit()  ;

            $year_id = $this->settings_model->class_schedule_save($postdata);

            $postdata_1 = new stdClass();
            $postdata_1->YearId = $year_id;
            $postdata_1->workersId = $this->workersId;

            $result = $this->workers_model->addtomyschoolyear($postdata_1);
            $result['year_id'] = $year_id;
            echo json_encode($result);
          break;
          case 'remove_schoolyear':
            // code...
          
          $postdata = array(
                'YearId'=>$this->input->post('id'),
                'workersId'=>$this->workersId
                );
          $result = $this->workers_model->remove_schoolyear($postdata); 
            break;
            case 'remove_student':
            $result = $this->workers_model->remove_student($this->input->post('student_id'),$this->workersId,$this->input->post('year_id'));
            break;
          break;
          default:
            // code...
            break;
        }
      exit();
    }
    if (!$workersId) {
      // code...
      redirect(dashboard);
    }
    $data = new stdClass();
    $data->worker_id = $workersId;
    $data->info = $this->workers_model->getWorker($workersId);
    if (!empty($data->info)) {
      // code...
      $data->info->profile = profile($data->info);

    }

    $data->schoolyears = $this->settings_model->listschoolyears();

    $data->myschoolyear = $this->workers_model->listmyschoolyear($workersId);
    //$data->YearId = $_GET['year'];

    $data->sidebarcollapse = true;
    $data->active=null;
    $data->content = 'workers/new_profile';

    $this->template->dashboard($data);

  }

  public function my_students($worker_id=0,$year_id=0)
  {
    if ($worker_id == 0) {
      // code...
      $worker_id = $this->workersId;
    }

    if ($this->input->post()) {
      // code...
      $form = $this->input->post('form');
        switch ($form) {
          case "add_schoolyear":
            $postdata = new stdClass();
            $postdata->YearStart = $this->input->post('startdate');
            $postdata->YearEnd = $this->input->post('enddate');

            $year1 = $postdata->YearStart;
            $year2 = $postdata->YearEnd;
            $date= getAge($year1,$year2);
            //$count = $date->y;
            //echo  json_encode (array  ('status'=>false,'msg'=>$year_count->y ));

            if ($year2 < $year1) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid date!'));
              exit();
            }

            if ($date->y > 0) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be more than a year.'));
              exit();
            }

            
            if (($date->y * 12) + $date->m  <= 8 ) {
                // code...

              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be less than 8 months.'));
              exit();

            
            }

            exit()  ;

            $year_id = $this->settings_model->class_schedule_save($postdata);

            $postdata_1 = new stdClass();
            $postdata_1->YearId = $year_id;
            $postdata_1->workersId = $this->workersId;

            $result = $this->workers_model->addtomyschoolyear($postdata_1);
            $result['year_id'] = $year_id;
            echo json_encode($result);
          break;
          case 'remove_schoolyear':
            // code...
          
          $postdata = array(
                'YearId'=>$this->input->post('id'),
                'workersId'=>$this->worker_id
                );
          $result = $this->workers_model->remove_schoolyear($postdata); 
            break;
            case 'remove_student':
            $result = $this->workers_model->remove_student($this->input->post('student_id'),$worker_id,$this->input->post('year_id'));
            break;
            case 'remove_nut':
            $result = $this->weighing_model->remove($this->input->post('id'));
            break;
          default:
            // code...
            break;
        }
      exit();
    }
    $data = new stdClass();

    $data->info = $this->workers_model->getWorker($worker_id);
    if (!empty($data->info)) {
      // code...
      $data->info->profile = profile($data->info);
    }

    $data->standard_score = null;
    $data->schoolyears = $this->settings_model->listschoolyears();
    $data->myschoolyear = $this->workers_model->listmyschoolyear($worker_id);
    $data->year_id = $year_id;
    $data->worker_id = $worker_id;
    $data->center_id = $this->workers_model->get_center($worker_id);
    $data->sidebarcollapse = true;
    $data->active=null;
    $data->content = 'workers/my_students';

    $this->template->dashboard($data);

  }


  public function assessments($worker_id=0,$year_id=0)
  {
    if ($worker_id == 0) {
      // code...
      $worker_id = $this->workersId;
    }

    if ($this->input->post()) {
      // code...
      $form = $this->input->post('form');
        switch ($form) {
          case "add_schoolyear":
            $postdata = new stdClass();
            $postdata->YearStart = $this->input->post('startdate');
            $postdata->YearEnd = $this->input->post('enddate');

            $year1 = $postdata->YearStart;
            $year2 = $postdata->YearEnd;
            $date= getAge($year1,$year2);
            //$count = $date->y;
            //echo  json_encode (array  ('status'=>false,'msg'=>$year_count->y ));

            if ($year2 < $year1) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid date!'));
              exit();
            }

            if ($date->y > 0) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be more than a year.'));
              exit();
            }

            
            if (($date->y * 12) + $date->m  <= 8 ) {
                // code...

              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be less than 8 months.'));
              exit();

            
            }

            exit()  ;

            $year_id = $this->settings_model->class_schedule_save($postdata);

            $postdata_1 = new stdClass();
            $postdata_1->YearId = $year_id;
            $postdata_1->workersId = $this->workersId;

            $result = $this->workers_model->addtomyschoolyear($postdata_1);
            $result['year_id'] = $year_id;
            echo json_encode($result);
          break;
          case 'remove_schoolyear':
            // code...
          
          $postdata = array(
                'YearId'=>$this->input->post('id'),
                'workersId'=>$this->worker_id
                );
          $result = $this->workers_model->remove_schoolyear($postdata); 
            break;
            case 'remove_student':
            $result = $this->workers_model->remove_student($this->input->post('student_id'),$worker_id,$this->input->post('year_id'));
            break;
            case 'remove_nut':
            $result = $this->weighing_model->remove($this->input->post('id'));
            break;
          default:
            // code...
            break;
        }
      exit();
    }
    $data = new stdClass();

    $data->info = $this->workers_model->getWorker($worker_id);
    if (!empty($data->info)) {
      // code...
      $data->info->profile = profile($data->info);
    }

    $data->standard_score = null;
    $data->schoolyears = $this->settings_model->listschoolyears();
    $data->myschoolyear = $this->workers_model->listmyschoolyear($worker_id);
    $data->year_id = $year_id;
    $data->worker_id = $worker_id;
    $data->center_id = $this->workers_model->get_center($worker_id);
    $data->sidebarcollapse = true;
    $data->active=null;
    $data->content = 'workers/index-assessment';

    $this->template->dashboard($data);

  }

  public function nutritions($worker_id=0,$year_id=0)
  {
    if ($worker_id == 0) {
      // code...
      $worker_id = $this->workersId;
    }

    if ($this->input->post()) {
      // code...
      $form = $this->input->post('form');
        switch ($form) {
          case "add_schoolyear":
            $postdata = new stdClass();
            $postdata->YearStart = $this->input->post('startdate');
            $postdata->YearEnd = $this->input->post('enddate');

            $year1 = $postdata->YearStart;
            $year2 = $postdata->YearEnd;
            $date= getAge($year1,$year2);
            //$count = $date->y;
            //echo  json_encode (array  ('status'=>false,'msg'=>$year_count->y ));

            if ($year2 < $year1) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid date!'));
              exit();
            }

            if ($date->y > 0) {
              // code...
              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be more than a year.'));
              exit();
            }

            
            if (($date->y * 12) + $date->m  <= 8 ) {
                // code...

              echo json_encode(array('status'=>false,'msg'=>'Invalid! School year should not be less than 8 months.'));
              exit();

            
            }

            exit()  ;

            $year_id = $this->settings_model->class_schedule_save($postdata);

            $postdata_1 = new stdClass();
            $postdata_1->YearId = $year_id;
            $postdata_1->workersId = $this->workersId;

            $result = $this->workers_model->addtomyschoolyear($postdata_1);
            $result['year_id'] = $year_id;
            echo json_encode($result);
          break;
          case 'remove_schoolyear':
            // code...
          
          $postdata = array(
                'YearId'=>$this->input->post('id'),
                'workersId'=>$this->worker_id
                );
          $result = $this->workers_model->remove_schoolyear($postdata); 
            break;
            case 'remove_student':
            $result = $this->workers_model->remove_student($this->input->post('student_id'),$worker_id,$this->input->post('year_id'));
            break;
            case 'remove_nut':
            $result = $this->weighing_model->remove($this->input->post('id'));
            break;
          default:
            // code...
            break;
        }
      exit();
    }
    $data = new stdClass();

    $data->info = $this->workers_model->getWorker($worker_id);
    if (!empty($data->info)) {
      // code...
      $data->info->profile = profile($data->info);
    }

    $data->standard_score = null;
    $data->schoolyears = $this->settings_model->listschoolyears();
    $data->myschoolyear = $this->workers_model->listmyschoolyear($worker_id);
    $data->year_id = $year_id;
    $data->worker_id = $worker_id;
    $data->center_id = $this->workers_model->get_center($worker_id);
    $data->sidebarcollapse = true;
    $data->active=null;
    $data->content = 'workers/index-nutrition';

    $this->template->dashboard($data);

  }

  public function students($worker=0,$center=0)
  {
    // code...
    if (!$worker) {
      // code...
      echo json_encode(noinput());
    }
    if ($center == 0) {
      // code...
      $center = $this->workers_model->get_center($worker);
    }

    if ($this->input->post()) {
      // code...

    if($result = $this->workers_model->my_students($worker,$center,$this->input->post('class_schedule'))){
        $data = array();
        $i=1;
      foreach ($result as $key => $value) {
        // code...
        $data[] = array( 
          'no'=>$i,
          'id'=>$value->student_id,
          'name'=>'<a href="'.site_url('students/nutritions/'.$value->student_id).'" title="Edit user information" style="min-width:100px !important;">'.$value->student_name.'</a>',
          'age'=>$value->age,
          'gender'=>gender($value->gender),
          'address'=>$value->address,
          'student_type'=>studtype($value->student_type),
          'class_schedule'=>tomdy($value->class_start).'-'.tomdy($value->class_end)
        
      );
        $i++;
      }
    echo json_encode(array('data'=>$data));


    }else{

    echo json_encode(array('data'=>false));
    }

      exit();
    }


    if($result = $this->workers_model->my_students($worker,$center)){
        $data = array();
        $i=1;
      foreach ($result as $key => $value) {
        // code...
        $data[] = array( 
        $i,
        $value->student_name,
        $value->age,
        gender($value->gender),
        $value->address,
        studtype($value->student_type),
        tomdy($value->class_start).'-'.tomdy($value->class_end),

        '<a href="'.site_url('students/profile/'.$value->student_id).'" class="btn btn-sm btn-info" title="Edit user information"><i class="fas fa-user"></i></a> <button type="button" class="btn btn-sm btn-default btn-edit-student" data-id="'.$value->student_id.'"  data-year_id="'.$value->year_id.'"><i class="fas fa-edit"></i></button> <button type="button" title="Remove this student"class="btn btn-sm btn-danger btn-remove-student" data-id="'.$value->student_id.'"  data-id="'.$value->student_id.'" data-year_id="'.$value->year_id.'"><i class="fas fa-trash"></i></button>');
        $i++;
      
      }
    echo json_encode(array('data'=>$data));


    }else{

    echo json_encode(array('data'=>false));
    }


  }

  public function select_students($worker=0,$center=0)
  {
    // code...
    if (!$worker) {
      // code...
      echo json_encode(noinput());
    }
    if ($center == 0) {
      // code...
      $center = $this->workers_model->get_center($worker);
    }

    if ($this->input->post()) {
      // code...

    if($result = $this->workers_model->my_students($worker,$center,$this->input->post('class_schedule'))){
        $data = array();
      foreach ($result as $key => $value) {
        // code...
            $data[] = array('text'=>$value->student_name  ,'value'=>$value->student_id );


      }
    echo json_encode(array('status'=>true,'data'=>$data));


    }else{

    echo json_encode(array('status'=>false,'data'=>false));
    }

      exit();
    }


    if($result = $this->workers_model->my_students($worker,$center)){
        $data = array();
      foreach ($result as $key => $value) {

      }
    echo json_encode(array('data'=>$data));


    }else{

    echo json_encode(array('data'=>false));
    }


  }

    public function addtomyschoolyear($data='')
    {
      // code...
      if ($this->input->post()) {
        // code...
        $data = new stdClass();
        //$data->workersId = $this->workersId;
        $data->workersId = $this->input->post('workersId');
        $data->YearId = $this->input->post('schoolyears');
        $result = $this->workers_model->addtomyschoolyear($data);
        echo json_encode($result);
        exit();
      }
      echo json_encode(array('status'=>false,'data'=>'No input data.'));

    }

    public function list_workers($value='')
    {
      // code...
      if($result = $this->workers_model->list_inactive_Workers()){
          $data = array();
        foreach ($result as $key => $value) {
          // code...
          $data[] = array(
            'text'=>$value->worker_name,
            'value'=>$value->worker_id

          );
        }
          echo json_encode(array('status'=>true,'data'=>$data));

       
      }else{
          echo json_encode(array('status'=>false,'data'=>array('text'=>'No data','value'=>0)));
        }

    }
    public function listall($type=0,$center=0)
    {
      if (isset($_GET['type'])) {
        // code...
        $type = $_GET['type'];
      }
      if ($type == 1) {
        // code...

            if ($all_workers = $this->workers_model->list_active_Workers()) {
              // code...
              $i=1;
              foreach ($all_workers as $key => $value) {
                // code...
               $data[] = array(
                  $i,
                  $value->worker_name,
                  $value->worker_address,
                  $value->center_name,
                  job_status($value->job_status), /*
                  tomdy($value->class_start),
                  tomdy($value->class_end),
                  $value->class_status, 
                  '<a href="students?worker='.$value->worker_id.'&year='.$value->year_id.'" class="nav-link">'.$value->total_students.'</a>', */
                  '<a class="btn btn-info btn-xs" href="'.site_url('workers/profile/').$value->worker_id.'" type="button"><i class="fas fa-list"></i></a>  <button class="btn btn-default btn-xs btn-edit" data-id="'.$value->worker_id.'" type="button"><i class="fas fa-edt"></i></button> <button class="btn btn-danger btn-xs btn-trash worker" data-id="'.$value->worker_id.'" type="button"><i class="fas fa-trash"></i></button>'
                ); 
               $i++;
              }
              echo json_encode(array('data'=>$data));
            }else{
              echo json_encode(array('data'=>array()));

            }

      }else{


    if ($all_workers = $this->workers_model->list_all_Workers()) {
      // code...
      $i=1;
      foreach ($all_workers as $key => $value) {
        // code...
       $data[] = array(

          $i,
          $value->worker_name,
          $value->worker_address,
          $value->center_name,
          job_status($value->job_status),/*

          '',
          '',
          '',
          '', */
          '<a class="btn btn-info btn-xs" href="'.site_url('workers/profile/').$value->worker_id.'" type="button"><i class="fas fa-list"></i></a>  <button class="btn btn-default btn-xs btn-edit" data-id="'.$value->worker_id.'" type="button"><i class="fas fa-edit"></i></button> <button class="btn btn-danger btn-xs btn-trash worker" data-id="'.$value->worker_id.'" type="button"><i class="fas fa-trash"></i></button>'
        ); 

               $i++;

      }
      echo json_encode(array('data'=>$data));
    }else{
      echo json_encode(array('data'=>array()));

    }

      }

    }

  public function studentweighing($value='')
  {
    // code...
    if ($this->input->post()) {
      $postdata = $this->input->post();
      // code...

      $this->load->model('students/students_model');

      ////  $students = $this->students_model->info($postdata['student_id']);
       // echo json_encode($students);
      //exit();

      $centerId = $this->workers_model->getMyCenterId($this->workersId);

      if(!$this->weighing_model->check($postdata['student_id'],$postdata['date_weighing'])){
        
        $data =  new stdClass();
        $data->student_id = $postdata['student_id'];
        $data->weight = $postdata['weight'];
        $data->height = $postdata['height'];
        $data->date_weighing = $postdata['date_weighing'];

        $students = $this->students_model->info($postdata['student_id']);
        $birthday = $students->birthDate;
        $gender = $students->gender;
        $age = getAge($birthday,$postdata['date_weighing']);
        $years = $age->y;
        $months = $age->m;

        $ageinmonth = ($age->y * 12)+$age->m;
        /*
        if ($ageinmonth < 24) {
          // code...
          $result = array('status'=>false,'msg'=>'Unsupported age of child.');  
          
        }*/
        //else{
        
        $this->load->helper('bmi_helper');
      
        $ideal_weight = ideal_weight($years,$months);
        $data->wfa_percentage = ($data->weight/$ideal_weight) * 100;
        $data->wfa = get_wfa($data->wfa_percentage);

        $ideal_height = ideal_height($years,$students->gender);
        $data->hfa_percentage =($data->height/$ideal_height) * 100;
        $data->hfa = get_hfa($data->hfa_percentage);

        $weight_on_child_height = weight_on_child_height($ageinmonth,$data->height); //ideal weight base on child height;


          $weight_on_child_height = weight_on_child_height($ageinmonth,$data->height); //ideal weight base on child height;
          $data->wfh_percentage = ($postdata['weight']/$weight_on_child_height) * 100;
         // $data->wfh = get_wfh($data->wfh_percentage);   
          $data->wfh = get_whz($ageinmonth,$gender,$data->height,data->weight);
          $result = $this->weighing_model->add($data);

        //}

        echo json_encode($result);
      }else{
        echo json_encode(showresponse(3));
      }

    }else{
      echo json_encode(noinput());
    }
  }

  public function student_nutritions($worker_id=0,$year_id=0,$weighing=0)
  {
    // code..

    $center_id = $this->workers_model->get_center($worker_id);

    $this->load->model('eccd/eccd_model');
    $this->load->model('students/students_model');
    $result = $this->eccd_model->listachild($weighing,$year_id,$center_id,$worker_id);

    if(!empty($result)){
    // = $this->weighing_model->get_nutritions($postdata)){

              $i=1;
              $data = array();

              foreach ($result as $key => $value) {
                // code...
                $status = '';

                $arr_1 = array($value->wfa,$value->hfa,$value->wfh);
                if ($value->wfa =='UW' || $value->wfa =='SUW' || $value->wfh == 'SAM' || $value->wfh =='MAM'  || $value->wfh == 'SW' || $value->wfh =='W') {
                  // code...
                  $status = 'Malnourish';
                }

                if (in_array('OB',$arr_1) || in_array('OV',$arr_1) || in_array('OW',$arr_1)) {
                  // code...
                   if ($value->hfa == 'T' || $value->hfa == 'ST') {
                    // code...
                  $status = 'Malnourish';                  

                  }else{
                  $status = 'Obese';

                  }

                }
                if ($value->wfa =='N' && $value->wfh == 'N') {
                  // code...
                  $status = 'Normal';
                }

      $info = $this->students_model->info($value->student_id);
      $deworming = '';
      $vitamin_a = '';
      if($immunizations =$this->students_model->getimmunizations($value->student_id)){
          foreach ($immunizations as $i => $v) {
            // code...
            if ($v->type_immunization == 'deworming') {
              // code...
              $deworming =toymd($v->date_immunization);
            }

            if ($v->type_immunization == 'vitamin_a') {
              // code...
              $vitamin_a = toymd($v->date_immunization);
            }

          }
      }
                

        $ageinmonths = $info->age;

        $getage = getAge($info->birthDate);
          $ageinmonths  = ($getage->y * 12) + $getage->m;

      if ( isset($value ->date_weighing )) {
        // code...
          $getage= getAge ($info->birthDate,$value->date_weighing);
          $ageinmonths  = ($getage->y * 12) + $getage->m;

      }
               $data[] = array(
                  '<a class="link" href="'.site_url('students/nutritions/').$value->student_id.'" type="button"><i class=" fa fa-list"></i></a>',
                  $i,
                  $info->fName,
                  $info->mName,
                  $info->lName,
                  gender($value->gender),
                  toymd($info->birthDate),
                  $ageinmonths,
                  sector($info->sector),
                  $deworming,
                  $vitamin_a,                
                  !empty($value->date_weighing) ? toymd($value->date_weighing) :'',
                  $value->weight,
                  $value->height,
                  $value->wfa,
                  $value->hfa,
                  $value->wfh,
                  $status
                ); 
               $i++;
              }
      echo json_encode(array('data'=>$data));
    }else{
      echo json_encode(array('data'=>array()));

    }

  }

  public function student_ass($value='')
  {
    // code...
  }
  public function get_myschoolyear($worker_id=0)
  {
    // code...
   $result = $this->workers_model->listmyschoolyear($worker_id);
    $data = array();
   if (!empty($result)) {
     // code...
    foreach ($result as $key => $value) {
      // code...
      $data[] =  array('value'=>$value->year_id,'text'=>cmonthYear($value->class_start).' - '.cmonthYear($value->class_end));
    }
    echo json_encode($data);
   }else{
    echo json_encode($data[]=array('value'=>0,'text'=>'No data.'));
   }
  }

 } 


